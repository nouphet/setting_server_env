#!/bin/bash

# get config files
cd ~
wget https://raw.github.com/nouphet/dotfiles/master/dot.gitconfig
mv dot.gitconfig .gitconfig

yum -y install yum-priorities

echo "
## add epel repository for CentOS 5 32bit
# cd /usr/local/src/
# wget http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/5/i386/epel-release-5-4.noarch.rpm
# rpm -ivh epel-release-5-4.noarch.rpm

## add epel repository for CentOS 6 64bit
# cd /usr/local/src/
# wget http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/x86_64/epel-release-6-7.noarch.rpm
# rpm -ivh epel-release-6-7.noarch.rpm

## add epel repository for CentOS 6 32bit
# cd /usr/local/src/
# wget http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/i386/epel-release-6-7.noarch.rpm
# rpm -ivh epel-release-6-7.noarch.rpm
"

yum -y install screen git tree dstat etckeeper
cd /etc
etckeeper init
etckeeper pre-commit
etckeeper pre-commit
etckeeper pre-install
etckeeper post-install
etckeeper commit

gem install rak

# define git
git config --global core.editor 'vim -c "set fenc=utf-8"'

chkconfig ntpd on
chkconfig ntpd --list
/etc/init.d/ntpd start

# Stop Services for CentOS 5
chkconfig yum-updatesd off
chkconfig pcscd off
chkconfig bluetooth off

# disable SELinux
getenforce
setenforce 0
getenforce
vim /etc/sysconfig/selinux

# disable ip6tables
chkconfig ip6tables off
chkconfig ip6tables --list
