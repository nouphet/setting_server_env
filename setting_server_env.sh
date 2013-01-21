#!/bin/bash

USER=`whoami`

if [ "$USER" != 'root' ]
then
    echo "rootでコマンドを実行してください。"
    echo "Press Enter"
    read Enter
    exit 1
else
    echo "rootです。"
    echo "このまま処理を続行します。"
    echo "Press Enter"
    read Enter
fi

echo "cd /usr/local/src/"
cd /usr/local/src/

# タイムゾーンの変更
# date
# cp -p /usr/share/zoneinfo/Japan /etc/localtime
# date

# 日本語関連のパッケージをグループインストール
# yum -y groupinstall "Japanese Support"

# vim /etc/sysconfig/i18n
# LANG="ja_JP.UTF-8"
# source /etc/sysconfig/i18n 
# echo $LANG

#  vi ~/.bash_profile
# 最終行に追記
# LANG=ja_JP.UTF-8
# export LANG
# source ~/.bash_profile 
# echo $LANG 

echo "yum -y install ntp vim fping wget curl git"
yum -y install ntp vim fping wget curl git


echo "## Setup for root env"
echo "# Get .bashrc"
cd ~/
wget --no-check-certificate https://raw.github.com/nouphet/dotfiles/master/dot.bashrc_for_CentOS
if [ -f .bashrc ]; then
	mv .bashrc .bashrc_`date +%Y%m%d%H%M%S`.org
fi
mv dot.bashrc_for_CentOS .bashrc
ls -l ~/.bashrc
echo "Press Enter"
read Enter

echo "# get config files"
cd ~/
wget --no-check-certificate https://raw.github.com/nouphet/dotfiles/master/dot.gitconfig --no-check-certificate
if [ -f .gitconig ]; then
	mv .gitconfig .gitconfig_`date +%Y%m%d%H%M%S`
fi
mv dot.gitconfig ~/.gitconfig
ls -l ~/.gitconfig
echo "Press Enter"
read Enter

echo "# setup sudo"
visudo
echo "Press Enter"
read Enter

echo "## install yum-priorities"
yum -y install yum-priorities
echo "Press Enter"
read Enter


echo "## install dstat"

if [ `rpm -q dstat` = "dstat-0.7.2-1.el5.rfx" ]; then
	echo "`rpm -q dstat` がインストールされています。"
	echo "`rpm -q dstat` をアンインストールします。"
else
	echo "`rpm -q dstat` がインストールされています。"
	echo "dstat-0.7.2-1.el5.rfx.noarch.rpm をインストールします。"
	cd /usr/local/src/
	rpm -e dstat
	wget ftp://ftp.univie.ac.at/systems/linux/dag/redhat/el5/en/x86_64/extras/RPMS/dstat-0.7.2-1.el5.rfx.noarch.rpm
	rpm -ivh dstat-0.7.2-1.el5.rfx.noarch.rpm
fi

echo "Press Enter"
read Enter

echo "## add epel repository for CentOS 6"
if [ -f /etc/redhat-release ]
then
    CHK=`egrep "CentOS release 5|Red Hat Enterprise Linux .* 5" /etc/redhat-release`
    if [ "$CHK" != '' ]
    then
        if [ `uname -a | grep x86_64 | awk '{ print $12 }'` == "x86_64" ]
        then
            echo ""
            echo "#########################################################################"
            echo "RHEL 5.x / CentOS 5.x / OEL 5.x x86_64 が検出されました。"
            echo "#########################################################################"
            echo "# add epel repository for CentOS 5 64bit"
	    wget http://ftp.riken.jp/Linux/fedora/epel/5/x86_64/epel-release-5-4.noarch.rpm
	    rpm -ivh epel-release-5-4.noarch.rpm
        else
            echo ""
            echo "#########################################################################"
            echo "RHEL 5.x / CentOS 5.x / OEL 5.x 386 が検出されました。"
            echo "#########################################################################"
            echo "# add epel repository for CentOS 5 32bit"
            cd /usr/local/src/
            wget http://ftp.riken.jp/Linux/fedora/epel/5/i386/epel-release-5-4.noarch.rpm
            rpm -ivh epel-release-5-4.noarch.rpm
            #exit 1
        fi
        # Stop Services for CentOS 5
        chkconfig yum-updatesd off
        chkconfig pcscd off
        chkconfig bluetooth off
        chkconfig cups off
    else
        if [ `uname -a | grep x86_64 | awk '{ print $12 }'` == "x86_64" ]
        then
            echo ""
            echo "#########################################################################"
            echo "RHEL 6.x / CentOS 6.x / OEL 6.x x86_64 が検出されました。"
            echo "#########################################################################"
            echo "# add epel repository for CentOS 6 64bit"
            cd /usr/local/src/
            wget http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
            rpm -ivh epel-release-6-8.noarch.rpm
        else
            echo ""
            echo "#########################################################################"
            echo "RHEL 6.x / CentOS 6.x / OEL 6.x 386 が検出されました。"
            echo "#########################################################################"
            echo "# add epel repository for CentOS 6 32bit"
            cd /usr/local/src/
            wget http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
            rpm -ivh epel-release-6-8.noarch.rpm
        fi
        # Stop Services for CentOS 6
        chkconfig cups off
    fi
fi
echo "Press Enter"
read Enter

yum -y install screen git tree ack
echo "Press Enter"
read Enter

yum --enablerepo=epel -y install etckeeper
echo "Press Enter"
read Enter

yum --enablerepo=epel -y install bash-completion
echo "Press Enter"
read Enter

cd /etc
etckeeper init
#etckeeper pre-commit
#etckeeper pre-install
#etckeeper post-install
etckeeper commit
echo "Press Enter"
read Enter

gem install rak
echo "Press Enter"
read Enter

echo "# define git"
git config --global core.editor 'vim -c "set fenc=utf-8"'
git config --global http.sslVerify false
echo "Press Enter"
read Enter

echo "# 時刻同期デーモンの有効化"
date
chkconfig ntpd on
chkconfig ntpd --list
/etc/init.d/ntpd start
ntpq -p
NTP_IP=`ntpq -p |grep -v remote |grep -v "=====" |head -1 |awk '{print $2}'`
/etc/init.d/ntpd stop
ntpdate $NTP_IP
/etc/init.d/ntpd start
date
echo "Press Enter"
read Enter

echo "# disable SELinux"
getenforce
setenforce 0
getenforce
vim /etc/sysconfig/selinux

echo "# disable ip6tables"
chkconfig ip6tables off
chkconfig ip6tables --list

echo "# finishing message"
echo ""
echo "iptablesを必要に応じて設定して下さい。"
echo ""
echo "サーバをリブートして下さい。"
echo "コマンドを実行してください。 reboot"
echo "Press Enter"
read Enter
