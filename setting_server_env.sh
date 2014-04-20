#!/bin/bash

USER=`whoami`

if [ "$USER" != 'root' ]
then
    echo "rootでスクリプトを実行してください。"
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
yum -y groupinstall "Development tools"


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

echo "# get config files"
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

echo "## install yum-priorities"
yum -y install yum-priorities
#echo "Press Enter"
#read Enter


echo "## install dstat"

if [ `rpm -q dstat` == "dstat-0.7.2-1.el5.rfx" ]; then
        echo "`rpm -q dstat` がインストールされています。"
else
        echo "dstat-0.7.2-1.el5.rfx 以外のバージョン (`rpm -q dstat`) がインストールされています。"
        echo "`rpm -q dstat` をアンインストールして、dstat-0.7.2-1.el5.rfx.noarch.rpm をインストールします。"
        cd /usr/local/src/
        rpm -e dstat
        wget ftp://ftp.univie.ac.at/systems/linux/dag/redhat/el5/en/x86_64/extras/RPMS/dstat-0.7.2-1.el5.rfx.noarch.rpm
        rpm -ivh dstat-0.7.2-1.el5.rfx.noarch.rpm
fi

#echo "Press Enter"
#read Enter

echo "## add epel repository for CentOS 4 or 5 or 6"
if [ -f /etc/redhat-release ]
then
    CHK=`egrep "CentOS release 4|Red Hat Enterprise Linux * 4|Red Hat Enterprise Linux ES release 4" /etc/redhat-release`
    if [ "$CHK" != '' ]
    then
        if [ `uname -a | grep x86_64 | awk '{ print $12 }'` == "x86_64" ]
        then
            echo ""
            echo "#########################################################################"
            echo "RHEL 4.x / CentOS 4.x / OEL 4.x x86_64 が検出されました。"
            echo "#########################################################################"
            echo "# add epel repository for CentOS 4 64bit"
            if [ `rpm -q epel-release` == "epel-release-4-10" ]
            then
                echo "`rpm -q epel-release`がインストール済みです。"
                echo "Go To Next."
                echo ""
            else
                echo "epel-release-4-10.noarch.rpmをインストールします。"
                cd /usr/local/src/
	        wget http://ftp.riken.jp/Linux/fedora/epel/4ES/x86_64/epel-release-4-10.noarch.rpm
	        rpm -ivh epel-release-4-10.noarch.rpm
            fi
        else
            echo ""
            echo "#########################################################################"
            echo "RHEL 4.x / CentOS 4.x / OEL 4.x 386 が検出されました。"
            echo "#########################################################################"
            echo "# add epel repository for CentOS 4 32bit"
            if [ `rpm -q epel-release` == "epel-release-4-10" ]
            then
                echo "`rpm -q epel-release`がインストール済みです。"
                echo "Go To Next."
                echo ""
            else
                echo "epel-release-4-10.noarch.rpmをインストールします。"
                cd /usr/local/src/
                wget http://ftp.riken.jp/Linux/fedora/epel/4ES/i386/epel-release-4-10.noarch.rpm
                rpm -ivh epel-release-4-10.noarch.rpm
            fi
        fi
        # Stop Services for CentOS 4
        chkconfig yum-updatesd off
        chkconfig pcscd off
        chkconfig bluetooth off
        chkconfig cups off
    fi
    CHK=`egrep "CentOS release 5|Red Hat Enterprise Linux .* 5|Red Hat Enterprise Linux ES release 5" /etc/redhat-release`
    if [ "$CHK" != '' ]
    then
        if [ `uname -a | grep x86_64 | awk '{ print $12 }'` == "x86_64" ]
        then
            echo ""
            echo "#########################################################################"
            echo "RHEL 5.x / CentOS 5.x / OEL 5.x x86_64 が検出されました。"
            echo "#########################################################################"
            echo "# add epel repository for CentOS 5 64bit"
            if [ `rpm -q epel-release` == "epel-release-5-4" ]
            then
                echo "`rpm -q epel-release`がインストール済みです。"
                echo "Go To Next."
                echo ""
            else
                echo "epel-release-5-4.noarch.rpmをインストールします。"
                cd /usr/local/src/
	        wget http://ftp.riken.jp/Linux/fedora/epel/5/x86_64/epel-release-5-4.noarch.rpm
	        rpm -ivh epel-release-5-4.noarch.rpm
            fi
        else
            echo ""
            echo "#########################################################################"
            echo "RHEL 5.x / CentOS 5.x / OEL 5.x 386 が検出されました。"
            echo "#########################################################################"
            echo "# add epel repository for CentOS 5 32bit"
            if [ `rpm -q epel-release` == "epel-release-5-4" ]
            then
                echo "`rpm -q epel-release`がインストール済みです。"
                echo "Go To Next."
                echo ""
            else
                echo "epel-release-5-4.noarch.rpmをインストールします。"
                cd /usr/local/src/
                wget http://ftp.riken.jp/Linux/fedora/epel/5/i386/epel-release-5-4.noarch.rpm
                rpm -ivh epel-release-5-4.noarch.rpm
            fi
        fi
        # Stop Services for CentOS 5
        chkconfig yum-updatesd off
        chkconfig pcscd off
        chkconfig bluetooth off
        chkconfig cups off
    fi
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

echo "# disable SELinux"
getenforce
setenforce 0
getenforce
#vim /etc/sysconfig/selinux
perl -p -i.bak -e 's/enforcing/disabled/g' /etc/selinux/config

echo "# disable ip6tables"
chkconfig ip6tables off
chkconfig ip6tables --list

echo "# finishing message"
echo ""
echo "iptablesを必要に応じて設定して下さい。"
echo ""
echo "サーバをリブートして下さい。"
echo "コマンドを実行してください。 reboot"
#echo "Press Enter"
#read Enter

