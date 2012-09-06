#!/bin/bash

# get config files
cd ~
wget https://raw.github.com/nouphet/dotfiles/master/dot.gitconfig
mv dot.gitconfig .gitconfig

yum -y install yum-priorities

echo "
## add epel repository for CentOS 5
# cd /usr/local/src/
# wget http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/5/i386/epel-release-5-4.noarch.rpm
# rpm -ivh epel-release-5-4.noarch.rpm
"

yum -y install screen git tree dstat etckeeper
cd /etc
etckeeper init
etckeeper commit
etckeeper pre-commit
etckeeper pre-commit
etckeeper pre-install
etckeeper post-install

gem install rak

# define git
git config --global core.editor 'vim -c "set fenc=utf-8"'

chkconfig ntpd on
chkconfig ntpd --list

# Stop Services for CentOS 5
chkconfig yum-updatesd off
chkconfig pcscd off
chkconfig bluetooth off

# disable SELinux
getenforce
setenforce 0
vim /etc/sysconfig/selinux

