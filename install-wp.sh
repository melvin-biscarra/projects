#!/bin/bash

# Install script for Latest WordPress on local dev

# Setup

# Hardcoded variables that shouldn't change much

# Path to MySQL
MYSQL='/usr/bin/mysql'

# DB Variables
echo "MySQL Host:"
read mysqlhost
export mysqlhost

echo "MySQL DB Name:"
read mysqldb
export mysqldb

echo "MySQL DB User:"
read mysqluser
export mysqluser

echo "MySQL User Password:"
read mysqlpass
export mysqlpass

# WP Variables
echo "Site Title:"
read wptitle
export wptitle

echo "Admin Username:"
read wpuser
export wpuser

echo "Admin Password:"
read wppass
export wppass

echo "Admin Email"
read wpemail
export wpemail

# Site Variables
echo "Site URL (ie, www.youraddress.com):"
read siteurl
export siteurl

echo "You will now be prompted for your MySQL password" 

# Setup DB & DB User
$MYSQL -uroot -p$mysqlrootpass -e "CREATE DATABASE IF NOT EXISTS $mysqldb; GRANT ALL ON $mysqldb.* TO '$mysqluser'@'$mysqlhost' IDENTIFIED BY '$mysqlpass'; FLUSH PRIVILEGES "

# Download latest WordPress and uncompress
wget http://wordpress.org/latest.tar.gz
tar zxf latest.tar.gz
mv wordpress/* ./


# Build our wp-config.php file
sed -e "s/localhost/"$mysqlhost"/" -e "s/database_name_here/"$mysqldb"/" -e "s/username_here/"$mysqluser"/" -e "s/password_here/"$mysqlpass"/" wp-config-sample.php > wp-config.php

# Grab our Salt Keys
SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s wp-config.php

# Run our install ...
curl -d "weblog_title=$wptitle&user_name=$wpuser&admin_password=$wppass&admin_password2=$wppass&admin_email=$wpemail" http://$siteurl/wp-admin/install.php?step=2

# Tidy up
rmdir wordpress
rm latest.tar.gz
rm wp-config-sample.php

# Download starkers
cd wp-content/themes/
wget https://github.com/viewportindustries/starkers/archive/master.zip
unzip master.zip
rm master.zip