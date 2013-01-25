#!/bin/bash

yum install -y zabbix20-agent
rm -f /etc/zabbix_agent.conf
rm -f /etc/zabbix/zabbix_agent.conf


perl -p -i.bak -e 's/"Server=127.0.0.1"/"Server=210.48.233.235"/g' /etc/zabbix_agentd.conf
perl -p -i.bak -e 's/"ServerActive=127.0.0.1"/"ServerActive=210.48.233.235"/g' /etc/zabbix_agentd.conf
perl -p -i.bak -e 's/"Hostname=Zabbix server"/"Hostname=system.hostname"/g' /etc/zabbix_agentd.conf

chkconfig zabbix-agent --list
chkconfig zabbix-agent on
chkconfig zabbix-agent --list

iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 10050 -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 10051 -j ACCEPT
cp -p /etc/sysconfig/iptables /etc/sysconfig/iptables.`date +%Y%m%d%H%M`
iptables-save > /etc/sysconfig/iptables

/etc/init.d/zabbix-agent start

