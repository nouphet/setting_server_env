#!/bin/bash

USER=`whoami`

if [ "$USER" != 'root' ]
then
    echo "rootでコマンドを実行してください。"
    read Enter
    exit 1
else
    echo "rootです。"
    echo "このまま処理を続行します。"
    read Enter
fi

## setup for root env
# get .bashrc
cd ~/
wget https://raw.github.com/nouphet/dotfiles/master/dot.bashrc_for_CentOS
mv .bashrc .bashrc.org
mv dot.bashrc_for_CentOS .bashrc

# get config files
cd ~/
wget https://raw.github.com/nouphet/dotfiles/master/dot.gitconfig
mv dot.gitconfig ~/.gitconfig

# setup sudo
visudo

## install yum-priorities
yum -y install yum-priorities

## add epel repository for CentOS 6 64bit
if [ -f /etc/redhat-release ]
then
    CHK=`egrep "CentOS release 5|Red Hat Enterprise Linux .* 5" /etc/redhat-release`
    if [ "$CHK" != '' ]
    then
        if [ `uname -a | grep x86_64 | awk '{ print $12 }'` == "x86_64" ]
        then
            echo ""
            echo "RHEL 5.x / CentOS 5.x / OEL 5.x x86_64 が検出されました。"
            # add epel repository for CentOS 5 32bit
            cd /usr/local/src/
            wget http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/5/i386/epel-release-5-4.noarch.rpm
            rpm -ivh epel-release-5-4.noarch.rpm
        else
            echo ""
            echo "RHEL 5.x / CentOS 5.x / OEL 5.x 386 が検出されました。"
            echo "対象のEPELリポジトリが設定されていません。"
            #exit 1
        fi
        # Stop Services for CentOS 5
        chkconfig yum-updatesd off
        chkconfig pcscd off
        chkconfig bluetooth off
    else
        if [ `uname -a | grep x86_64 | awk '{ print $12 }'` == "x86_64" ]
        then
            echo ""
            echo "RHEL 6.x / CentOS 6.x / OEL 6.x x86_64 が検出されました。"
            cd /usr/local/src/
            wget http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/x86_64/epel-release-6-7.noarch.rpm
            rpm -ivh epel-release-6-7.noarch.rpm
        else
            echo ""
            echo "RHEL 6.x / CentOS 6.x / OEL 6.x 386 が検出されました。"
            echo "対象のEPELリポジトリが設定されていません。"
            # add epel repository for CentOS 6 32bit
            cd /usr/local/src/
            wget http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/i386/epel-release-6-7.noarch.rpm
            rpm -ivh epel-release-6-7.noarch.rpm
        fi
    fi
fi

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
git config --global http.sslVerify false

# 時刻同期デーモンの有効化
chkconfig ntpd on
chkconfig ntpd --list
/etc/init.d/ntpd start


# disable SELinux
getenforce
setenforce 0
getenforce
vim /etc/sysconfig/selinux

# disable ip6tables
chkconfig ip6tables off
chkconfig ip6tables --list

# finishing message
echo ""
echo "iptablesを必要に応じて設定して下さい。"
echo ""
echo "サーバをリブートして下さい。"
echo "コマンドを実行してください。 reboot"
