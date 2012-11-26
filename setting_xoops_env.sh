#!/bin/bash

yum -y install php php-mysql php-mbstring php-pdo mysql-server httpd

chkconfig httpd on
chkconfig mysqld on

