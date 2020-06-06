<#
*****************************************************************************************************************
/*File Name       : create-mass-ad-users.ps1
* Project         : CloudSuite Single-Tenant
* Object          : Added Creating new CSV file with Random Passwords
* Purpose         : This Code is used to collect input CSV file & create Users and create new CSV file with passwords.
* Description     :This Script will Add new AD users from given csv file and with random passwords
* Author          : mnagulavancha
* Date            : 29-July-2016
*****************************************************************************************************************
#>

import-module -Name C:\inforbc\lib\standard\New-SWRandomPassword.psm1

#Read grains values using function
Function ReadGrain{
    param( $grainname,
           $defaultvalue
       )

    $grainname = (select-string C:\salt\conf\grains -pattern ('^'+$grainname) -CaseSensitive).line
    $length = $grainname.length
    $default = $defaultvalue
    

    if ($length -gt 0)
    {
        $pos = $grainname.IndexOf(":")
        $rightPart = $grainname.Substring($pos+1)
        return($rightPart.Trim())

    }
    else {
        return  $default
    }
    
    

}


[String]$STAGE_DIR=$args[0]
[String]$PRODUCT_NAME=$args[1]


#Function to zip files (works with ps version 3 and above)
function Create-ZipFile( $zipfilename, $sourcedir )
{
   Add-Type -Assembly System.IO.Compression.FileSystem
   $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
   [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir,
        $zipfilename, $compressionLevel, $True)
}
#Function to zip files using 7zip (works with ps version 2 and above)
function Create-7zip([String] $aDirectory, [String] $aZipfile){
    [string]$pathToZipExe = "$($Env:ProgramFiles)\7-Zip\7z.exe";
    [Array]$arguments = "a", "-tzip", "$aZipfile", "$aDirectory", "-r";
    $result = & $pathToZipExe $arguments;
    Write-Host $result
}

$stime = Get-Date -format 'yyyyMMddHHmmss'

$prefix=$env:ZZ_Cust_Pfx

Write-Host '*************************SSO Enable Flag start************************'
$SSOENABLED="False"

Write-Host "SSO ENABLED Flag default value : $SSOENABLED"

$SSOENABLED=$env:SSOENABLED


Write-Host "SSO ENABLED Flag value from CSP portal : $SSOENABLED"

Write-Host '*************************SSO Enable Flag end************************'
 
write-host "#################Users Upload started in Active Directory Server at $stime#################"
 
write-host "The customer prefix is: $prefix" 

#$CSV="C:\SRSCRIPTS\CCOEE\MassAddC.csv"

$domain=$(Get-ADDomain -Current LocalComputer).Name
#new-item .\execution4 -itemtype directory
write-host "Active Directory Domain is:  $domain" 

#$pwdCVSFileDir="C:\cloud\"+$prefix

$pwdCVSFileDir="C:\inforbc\tmp\"+$prefix+"-"+$stime

$csvfileName= $prefix+"-UsersPasswords-"+$stime+".csv" 

$pwdCVSFilePath=$pwdCVSFileDir+"\"+$csvfileName

$pwdCVSFileZip=$prefix+"-UsersPasswords-"+$stime+".zip" 


$atleaseOneUser=$FALSE
$adlevel="Yes"

#$CSV=$env:URL_MASSADUSERS_CSV_ZIP
$CSV="C:\inforbc\tmp\MassAddC.csv"

$path="CN=Users,DC=$($domain),DC=com"


write-host "Uploaded CSV file path is:  $CSV" 

write-host "Generated passwords CSV file path is:  $pwdCVSFilePath" 
write-host "Generated passwords CSV zip file path is:  $pwdCVSFileZip" 

$masterServer=ReadGrain -grainname 'MasterServer' -defaultvalue 'None'

$stackId=ReadGrain -grainname 'StackId' -defaultvalue 'None'

$agentGUID=ReadGrain -grainname 'agentGuid' -defaultvalue 'None'

$agentInstallation=ReadGrain -grainname 'agentInstallation' -defaultvalue 'new'
#new-item .\execution54 -itemtype directory

Write-Host '--------------------------------------------------------------------------'
Write-Host "Customer Prefix: $prefix"
Write-Host "MasterServer: $masterServer"
Write-Host "StackID : $stackID"
Write-Host "Agent GUID: $agentGUID"
Write-Host "Agent Installation flag: $agentInstallation"
Write-Host '--------------------------------------------------------------------------'
#new-item .\execution6 -itemtype directory
if(Test-Path $CSV) 
{            
        Try
        {
        #new-item .\execution7 -itemtype directory
        $FileName = [System.IO.Path]::GetFileName($CSV)
		#new-item .\execution8 -itemtype directory
    
        $measure_obj=Import-Csv $CSV | Measure-Object
        $no_users=$measure_obj.Count
		#new-item .\execution9 -itemtype directory

        Write-Host "Number of Users in Uploaded CSV: $no_users"

        $checkADgrp=$FALSE

        $adUsers = @()
        $Username="Username"
        $Pword="Password"
        $info="Information"
        
        $LSFLevel="No"
        $ADGroup="AD_LAWUSERS"

        $Users = Import-Csv -Path $CSV
		#new-item .\execution10 -itemtype directory       
                 
        foreach ($User in $Users)            
        {            
            
            $adlevel=$User.AdLevel
            Write-Host "ADLevel flag value from Uploaded CSV is : $adlevel"
            if ($adlevel) {

                #Write-Host "Before ADLevel is : $adlevel"
                $adlevel = $adlevel.substring(0,1).toupper()
                Write-Host "First letter of AD level: $adlevel"
                if($adlevel -eq ' '){

                    Write-Host "ADLevel flag is empty. Setting AD level to No"
                    $adlevel='N'
                }

            }else{

                Write-Host 'ADLevel flag is NULL. Setting AD level to No'
                 $adlevel='N'
            }

            Write-Host 'Verifying Uploaded CSV ADLevel flag is set to Yes OR SSOENABLED is False'
            
            if (($adlevel -eq "Y") -or ($SSOENABLED -eq "False"))
            {           
                
                $atleaseOneUser=$TRUE
                

                $Displayname = $User.FirstName + " " + $User.LastName
                     
                $UserFirstname = $User.FirstName            
                $UserLastname = $User.LastName  
                $SAM = $User.UserName            
                $UPN = $User.UserName + "@" + $domain + ".com"            
                $Description = $User.UserName + " is new User from Add Users Service Request from Cloudsuite portal"  
                $EMAIL=$User.Email
                $LSFLevel=$User.LsfLevel

                

                if($checkADgrp -eq $FALSE)
                {
                    
           
                    Try 
                    { 
                          #Check if the Group already exists 
                          $exists = Get-ADGroup $ADGroup 
                          Write-Host "[INFO] :Group $($ADGroup) already exists! Group creation skipped!" 
                   } 
                   Catch 
                   { 
                           Write-Host "Group $($ADGroup) creation started!"
                           Try{
                                New-ADGroup –Name “$ADGroup” –SamAccountName "$ADGroup" –GroupCategory Security –GroupScope DomainLocal –DisplayName “$ADGroup” –Path “$path" -Description "$("$ADGroup" +" Description")"
                           }
                           catch [Exception] {
                        
                             Write-Host "[ERROR] :Failed to create Active Directory Group: $ADGroup . Contact Infor Support!!"
                             write-host $_.Exception.GetType().FullName
                             write-host $_.Exception.Message; 
                             exit 521

                         }
                         Write-Host "[INFO] :Group $($ADGroup) created !" 
                   }
                   $checkADgrp=$TRUE
                }

            
                Try 
                { 
                      #Check if the Group already exists 
                      $exists = Get-ADUser $SAM 
                      Write-Host "[INFO] :User $($SAM) already exists! Reseting with new password!!"
                      $adUser = new-object PSObject
                      $adUser | Add-Member -MemberType NoteProperty -Name $Username -Value "$SAM"
                      $adUser | Add-Member -MemberType NoteProperty -Name $info -Value "User : $($SAM) already exists in AD, So Please check Admininstrator"
                      $NewPassword=New-SWRandomPassword -MinPasswordLength 14 -MaxPasswordLength 16 
                      Try{
                             $adUser=''                              
                             Set-ADAccountPassword -Identity "$SAM" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$NewPassword" -Force)
							 Write-Host "User $($SAM) already exists! Updated user with new password.  Adding to Password CSV file"
                             $adUser = new-object PSObject
                             $adUser | Add-Member -MemberType NoteProperty -Name $Username -Value "$SAM"
                             $adUser | Add-Member -MemberType NoteProperty -Name $Pword -Value "$NewPassword"
                             $adUser | Add-Member -MemberType NoteProperty -Name "Email-Address" -Value "$EMAIL"
                             $adUser | Add-Member -MemberType NoteProperty -Name "Added LSA" -Value "$LSFLevel"
                             $adUser | Add-Member -MemberType NoteProperty -Name "INFORBC AD Results" -Value "Password Reset for this user $SAM in INFORBC AD"

    	                     $adUsers += $adUser
                         }
                     catch [Exception] {
                        
                         Write-Host "[ERROR] :Reset password failed for the user: $SAM .  Contact Infor Support"
                         write-host $_.Exception.GetType().FullName
                         write-host $_.Exception.Message; 

                         exit 522

                     }                    
               } 
               Catch 
               {
           
                     $adUser=''
                     $Password=New-SWRandomPassword -MinPasswordLength 14 -MaxPasswordLength 16   
                     Write-Host "[INFO] :Adding User: $SAM to Active Directory with Random password "  

                     Write-Host "============================================================================================================================"
                     write-host "-Name  -DisplayName -SamAccountName -UserPrincipalName -GivenName -Surname -Description -EmailAddress -AccountPassword-Enabled -Path -ChangePasswordAtLogon –PasswordNeverExpires"
                     write-host  " $SAM   $SAM  $SAM $UPN $SAM $UserLastname $Description $EMAIL $true $path $false $true"

                     write-host "-Name "$SAM" -DisplayName "$SAM" -SamAccountName "$SAM" -UserPrincipalName "$UPN" -GivenName "$UserFirstname" -Surname "$UserLastname" -Description "$Description" -EmailAddress $EMAIL -AccountPassword dummypwd -Enabled $true -Path "$path" -ChangePasswordAtLogon $false –PasswordNeverExpires $true"
                     Write-Host "============================================================================================================================"
                     Try {             
                        New-ADUser -Name "$SAM" -DisplayName "$Displayname" -SamAccountName "$SAM" -UserPrincipalName "$UPN" -GivenName "$UserFirstname" -Surname "$UserLastname" -Description "$Description" -EmailAddress $EMAIL -AccountPassword (ConvertTo-SecureString "$Password" -AsPlainText -Force) -Enabled $true -Path "$path" -ChangePasswordAtLogon $false –PasswordNeverExpires $true
                     }
                     catch [Exception] {
                        
                         Write-Host "[ERROR] :Failed to add user : $SAM to Active Directory. Contact Infor Support."
                         write-host $_.Exception.GetType().FullName
                         write-host $_.Exception.Message; 

                         exit 523

                     }
                     Write-Host "[INFO] :Successfully Added user: $SAM into Active Directory with Random password "
                     #Start-Sleep -s 1

                     #Add user to Group
                     Write-Host "Adding user: $SAM into Active Directory group: $ADGroup"
                     Try{
                        Add-ADGroupMember -Identity "$ADGroup" -Member "$SAM"
                     }
                     catch [Exception] {
                       
                         Write-Host "[ERROR] : Failed Adding user: $SAM into Active Directory Group $ADGroup . Contact Infor Support"
                         write-host $_.Exception.GetType().FullName
                         write-host $_.Exception.Message; 

                         exit 524

                     }
				     Write-Host "Successfully Added user: $SAM into Active Directory group $ADGroup"

                     Write-Host "Adding into Password CSV file for user: $SAM" 
                     Try{ 
                         $adUser = new-object PSObject
                         $adUser | Add-Member -MemberType NoteProperty -Name $Username -Value "$SAM"
                         $adUser | Add-Member -MemberType NoteProperty -Name $Pword -Value "$Password"
                         $adUser | Add-Member -MemberType NoteProperty -Name "Email-Address" -Value "$EMAIL"
                         $adUser | Add-Member -MemberType NoteProperty -Name "Added LSA" -Value "$LSFLevel"
                         $adUser | Add-Member -MemberType NoteProperty -Name "INFORBC AD Results" -Value "New User Added to INFORBC AD"

    	                 $adUsers += $adUser
                       }
                       catch [Exception] {
                       
                         Write-Host "Failed Adding user: $SAM into Passwrod CSV file. Contact Infor Support"
                         write-host $_.Exception.GetType().FullName
                         write-host $_.Exception.Message; 

                         exit 525

                     }
	
	                #Start-Sleep -Seconds 1

               }            
          
                       
        }#End IF condition of ADLevel check
        }# End For loop of csv file 
        New-Item -Force -ItemType directory -Path $pwdCVSFileDir
        if($atleaseOneUser -eq $TRUE)
        {
            

            #Export adUsers object to CSV  file  
            Write-Host "Exporting all users to CSV file : $pwdCVSFilePath"     

            $adUsers | Export-Csv $pwdCVSFilePath -NoTypeInformation 
        }else{

             Write-Host "[WARNING] : No User Added to Active Directory. Verify Uploaded CSV file"  
             $adUser = new-object PSObject
             $adUser | Add-Member -MemberType NoteProperty -Name $info -Value "No User Added to Active Directory. Verify Uploaded CSV file!"
             $adUser | Export-Csv $pwdCVSFilePath -NoTypeInformation
        }
       
        #Compress-Archive -Path $pwdCVSFilePath -DestinationPath $pwdCVSFileZip

        if ( $(get-host).Version.Major -eq 2 ){
            Write-Host 'PowerShell Version: 2'
            Create-7zip -aDirectory $pwdCVSFileDir -aZipfile $pwdCVSFileZip
            Write-Host "Zipfile path for Password CSV : $pwdCVSFilePath"
        }
        else{
            Write-Host 'PowerShell Version: 3'
            Create-ZipFile -zipfilename $pwdCVSFileZip -sourcedir $pwdCVSFileDir
            Write-Host "Zipfile path for Password CSV : $pwdCVSFilePath"
        }

        #Using Cloudsuite protal webservice call like presinged URL to export 'C:\Windows\system32\CCOPatchTest1-UsersPasswords.zip' file to s3.

        #$env:Path = "C:\Python27";

        write-host "Password CSV file path is:  $pwdCVSFilePath" 
        write-host "Zipped Password CSV file path:  $pwdCVSFileZip" 

        write-host "STAGE_DIR:  $STAGE_DIR" 
        write-host "PRODUCT_NAME:  $PRODUCT_NAME"

        $pwdCVSFilePath=$STAGE_DIR+"\"+$PRODUCT_NAME+'\parameters\INFORBCAD01\AD\'
        
        $python="C:\Python27\python.exe"
		
        $env:Path += ";C:\Python27";
        $env:PATHEXT += ";.py"; 
        $uploadpypath = $STAGE_DIR+"\"+$PRODUCT_NAME+"\parameters\INFORBCAD01\AD\upload-userspwds-csv.py"
		write-host $uploadpypath $prefix $masterServer $stackID $pwdCVSFileZip $pwdCVSFileDir $agentGUID

        Try{

            write-host "Uploading Password ZIP file"
            $pr1=Start-Process -filepath $python -ArgumentList "$uploadpypath $prefix $masterServer $stackID $pwdCVSFileZip $pwdCVSFilePath $agentGUID $agentInstallation" -PassThru -WindowStyle Hidden -Wait
            write-host $pr1.exitcode        
            write-host $pr1.StandardOutput
            write-host $pr1.StandardError
		    #new-item .\execution200 -itemtype directory        
            exit $pr1.exitcode
         }
        catch [Exception] {
                       
            Write-Host "[ERROR] :Failed to Upload Password ZIP file to Amazon S3. Contact Infor Support"
            write-host $_.Exception.GetType().FullName
            write-host $_.Exception.Message; 

            exit 526

        }
}
catch [Exception]
{
  Write-Host "[ERROR] :Failed to Add users in INFORBC Active Directory. Contact Infor Support"
  write-host $_.Exception.GetType().FullName
  write-host $_.Exception.Message;
  exit 527

}
} else {    
        Write-Host "[ERROR] : Input CSV file not present in the path : $CSV . Contact Infor Support."        
        Write-Warning "$CSV : No such file found" 
        exit 528           
    }