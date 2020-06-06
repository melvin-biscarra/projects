###
#Name: ad-password-reset.ps1
#Description: Resetting Lawson LADP user provided new password from Service request 
#PreRequisties: PowerShell version 3.0 above recomended.
#Version: 1.0
# Created:     17/06/2016
# Updated:     19/09/2016
#Author: mnagulavancha
#Usage: ad-password-reset.ps1 <UserID> <newPassword>
##
###

Write-Host 'Server powershell version'

write-host $(get-host).Version.Major


[String]$SAM=$env:APPLICATION_USER_ID
[String]$newPWD=$env:NEW_PASSWORD
[String]$agent_cmd_id=$env:AGENT_COMMAND_ID

Write-Host '------------------------------'
Write-Host 'Inputs from Service Request'
Write-Host $SAM
Write-Host $agent_cmd_id
#Write-Host $newPWD
Write-Host '------------------------------'



$outfile1='C:\cspagent\logs\'+$agent_cmd_id+'.out'


if (!$SAM -or !$newPWD) {
write-host "PLease supply require arguments"
write-host "ad-password-reset.ps1 `"<UserID>`" `"<newPassword>`""
write-host "For Example:"
write-host "ad-password-reset.ps1 `"demo1`" `"India@Mode2014to19`""

$out_dict='{"STATUS": "ERROR", "CODE": "INVALID_PWD",  "MSG": "The password or user id is not provided or empty password value","RET_VAL": ""}'
$out_dict | Set-Content $outfile1
exit 1
}
else {

    Try 
    { 
            #Checking if the User already exists 
            $exists = Get-ADUser $SAM 
            Write-Host "User $($SAM) is exists INFORBC.COM Activity directory ! Going to reseting with provided new password"

            #$adUser = new-object PSObject
            #$adUser | Add-Member -MemberType NoteProperty -Name $Username -Value "$SAM"
            #$adUser | Add-Member -MemberType NoteProperty -Name $info -Value "User : $($SAM) already exists in AD, So Please check Admininstrator"
            #$NewPassword=New-SWRandomPassword -MinPasswordLength 14 -MaxPasswordLength 16 

            Try{
                    $adUser=''                             
                    Set-ADAccountPassword -Identity "$SAM" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $newPWD -Force)
					Write-Host "User $($SAM) exists! and resetted with new password"                    

                    $out_dict='{"STATUS": "SUCCESS", "CODE": "SUCCESS_PWD_RESETED",  "MSG": "The Password Resetted successfully:'+ $($SAM)+'","RET_VAL": ""}'

                    $out_dict | Set-Content $outfile1
                  
                }
            catch [Exception] {
                        
                Write-Host "Updating new password for existing user: $SAM  having problem"
                write-host $_.Exception.GetType().FullName
                write-host $_.Exception.Message;

                $out_dict='{"STATUS": "ERROR", "CODE": "INVALID_PWD",  "MSG": "'+$_.Exception.Message+'" ,"RET_VAL": ""}'

                $out_dict | Set-Content $outfile1 
                exit 1

            }                    
    }
    catch{
        Write-Host "There is Error While resetting password to : $($SAM) User, becuase this user not existing in INFORBC.com domain Active Directory"
        write-host $_.Exception.GetType().FullName
        write-host $_.Exception.Message;         

        $out_dict='{"STATUS": "ERROR", "CODE": "RESET_PWD_FAILED",  "MSG": "'+$_.Exception.Message+'" ,"RET_VAL": ""}'
        $out_dict | Set-Content $outfile1 
        exit 1
    }

}
