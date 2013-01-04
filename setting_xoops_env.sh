#!/bin/bash

yum -y install php php-mysql php-mbstring php-mcrypt php-pdo mysql-server httpd php-xml php-xmlrpc php-gd ImageMagick curl libcurl

chkconfig httpd on
chkconfig mysqld on

/etc/init.d/httpd start
/etc/init.d/mysqld start

echo "Finish Environment Build, and Middle Ware Started"

