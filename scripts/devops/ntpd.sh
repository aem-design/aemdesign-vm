#!/bin/bash -eux

sudo su -
setenforce 0
chkconfig ntpd on
ntpdate pool.ntp.org
service ntpd start
systemctl enable ntpd
systemctl start ntpd
setenforce 1