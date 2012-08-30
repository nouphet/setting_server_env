#!/bin/bash

yum -y install yum-priorities

## add epel repository for CentOS 5
# cd /usr/local/src/
# wget http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/5/i386/epel-release-5-4.noarch.rpm
# rpm -ivh epel-release-5-4.noarch.rpm

yum -y install screen git tree dstat etckeep
gem install rak

chkconfig ntpd on
chkconfig ntpd --list

