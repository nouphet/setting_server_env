#!/bin/bash

# Copyright 2014, Cloud-ASIA Co., Ltd.
# Auther: Toshihiro Takehara aka nouphet
# All rights reserved - Do Not Redistribute

## パラメータの設定
### Set to Apache HTTP Server
SITE_DOMAIN="sample-domein.com"

### Set to MySQL Server
DB_NAME="sample-domein"
DB_ROOT_PASSWORD="P@ssword"
DB_USER_NAME="dbuser"
DB_USER_PASSWORD="P@ssword"

# ユーザのチェック
USER=`whoami`

if [ "$USER" != 'root' ]; then
    echo "rootユーザでスクリプトを実行してください。"
    echo "Press Enter to finish"
    read Enter
    exit 1
else
    echo "rootユーザです。"
    echo "このまま処理を続行します。"
    echo "Press Enter to Continue"
    read Enter
fi

echo "cd /usr/local/src/"
cd /usr/local/src/

echo "yum -y install ntp vim"
yum -y install ntp vim


# タイムゾーンの確認と変更
echo "日付表示の変更前確認"
date
cp -p /usr/share/zoneinfo/Japan /etc/localtime
echo "日付表示の変更後確認"
date

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

echo "# disable SELinux"
echo "## SELinux 設定変更前確認"
getenforce
setenforce 0
echo "## SELinux 設定変更後確認"
getenforce
#vim /etc/sysconfig/selinux
perl -p -i.bak -e 's/enforcing/disabled/g' /etc/selinux/config

echo "# disable ip6tables"
chkconfig ip6tables off
chkconfig ip6tables --list

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
#echo "Press Enter"
#read Enter

echo "## Setup for root env"
echo "# Get .bashrc"
cd ~/
wget --no-check-certificate https://raw.github.com/nouphet/dotfiles/master/dot.bashrc_for_CentOS
if [ -f .bashrc ]; then
	mv .bashrc .bashrc_`date +%Y%m%d%H%M%S`.org
fi
mv dot.bashrc_for_CentOS .bashrc
ls -l ~/.bashrc
#echo "Press Enter"
#read Enter

echo "# get Git Config files"
cd ~/
wget --no-check-certificate https://raw.github.com/nouphet/dotfiles/master/dot.gitconfig
if [ -f .gitconig ]; then
	mv .gitconfig .gitconfig_`date +%Y%m%d%H%M%S`
fi
mv dot.gitconfig ~/.gitconfig
ls -l ~/.gitconfig
#echo "Press Enter"
#read Enter

#echo "# setup sudo"
#visudo
#echo "Press Enter"
#read Enter


echo "## install dstat"

if [ `rpm -q dstat` == "dstat-0.7.2-1.el5.rfx" ]; then
        echo "`rpm -q dstat` がインストールされています。"
else
        echo "dstat-0.7.2-1.el5.rfx 以外のバージョン (`rpm -q dstat`) がインストールされています。"
        echo "`rpm -q dstat` をアンインストールして、dstat-0.7.2-1.el5.rfx.noarch.rpm をインストールします。"

        rpm -e dstat
        cd /usr/local/src/
        wget ftp://ftp.univie.ac.at/systems/linux/dag/redhat/el5/en/x86_64/extras/RPMS/dstat-0.7.2-1.el5.rfx.noarch.rpm
        rpm -ivh dstat-0.7.2-1.el5.rfx.noarch.rpm
fi

#echo "Press Enter"
#read Enter

echo "## add epel repository for CentOS 4 or 5 or 6"
if [ -f /etc/redhat-release ]
then
    CHK=`egrep "CentOS release 6|Red Hat Enterprise Linux .* 6|Red Hat Enterprise Linux ES release 6" /etc/redhat-release`
    if [ "$CHK" != '' ]
    then
        if [ `uname -a | grep x86_64 | awk '{ print $12 }'` == "x86_64" ]
        then
            echo ""
            echo "#########################################################################"
            echo "RHEL 6.x / CentOS 6.x / OEL 6.x x86_64 が検出されました。"
            echo "#########################################################################"
            echo "# add epel repository for CentOS 6 64bit"
            if [ `rpm -q epel-release` == "epel-release-6-8" ]
            then
                echo "`rpm -q epel-release`がインストール済みです。"
                echo "Go To Next."
                echo ""
            else
                echo "epel-release-6-8.noarch.rpmをインストールします。"
                cd /usr/local/src/
                wget http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
                rpm -ivh epel-release-6-8.noarch.rpm
            fi
        else
            echo ""
            echo "#########################################################################"
            echo "RHEL 6.x / CentOS 6.x / OEL 6.x 386 が検出されました。"
            echo "#########################################################################"
            echo "# add epel repository for CentOS 6 32bit"
            if [ `rpm -q epel-release` == "epel-release-6-8" ]
            then
                echo "`rpm -q epel-release`がインストール済みです。"
                echo "Go To Next."
                echo ""
            else
                echo "epel-release-6-8.noarch.rpmをインストールします。"
                cd /usr/local/src/
                wget http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
                rpm -ivh epel-release-6-8.noarch.rpm
            fi
        fi
        # Stop Services for CentOS 6
        chkconfig cups off
    fi
fi
#echo "Press Enter"
#read Enter

echo "yum --enablerepo=epel -y install screen git tree ack etckeeper bash-completion"
yum --enablerepo=epel -y install screen git tree ack etckeeper bash-completion
#echo "Press Enter"
#read Enter

cd /etc
etckeeper init
#etckeeper pre-commit
#etckeeper pre-install
etckeeper post-install
etckeeper commit
#echo "Press Enter"
#read Enter

if [ `gem list -i rak` == "false" ]; then
    echo "rak をインストールします。"
    #gem install rak
    gem install rak --version "~>1.4"
    #echo "Press Enter"
    #read Enter
else
    echo "下記の rak がインストールされています。"
    gem list -d "rak"
fi
echo ""

echo "# define git"
git config --global core.editor 'vim -c "set fenc=utf-8"'
git config --global http.sslVerify false
#echo "Press Enter"
#read Enter

echo "ApacheとPHPをインストールします。"
yum -y install httpd php php-cli php-curl php-pear mysql-server php-mysql curl imagemagick php-imagick
chkconfig httpd on
chkconfig httpd --list
/etc/init.d/httpd start

echo "MySQL Serverをインストールします。"
yum -y install mysql-server
chkconfig mysqld on
chkconfig mysqld --list

echo "MySQL Serverを初期設定します。"
/etc/init.d/mysqld start
# ここで初期設定スクリプトを実行
# パスワード設定などもここで。
/usr/bin/mysqladmin -u root password $DB_ROOT_PASSWORD
/usr/bin/mysqladmin -u root -p$DB_ROOT_PASSWORD -h localhost.localdomain password $DB_ROOT_PASSWORD

echo "# finishing message"
echo ""
echo "iptablesを必要に応じて設定して下さい。"
echo ""
echo "サーバをリブートして下さい。"
echo "コマンドを実行してください。 reboot"
#echo "Press Enter"
#read Enter

