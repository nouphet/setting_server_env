#!/bin/bash

yum -y install screen git tree dstat
gem install rak

chkconfig ntpd on
chkconfig ntpd --list

