#!/bin/bash -eux

sudo echo nameserver 8.8.8.8 >> /etc/resolv.conf
sudo echo nameserver 8.8.4.4 >> /etc/resolv.conf

sudo yum -y --enablerepo=extras install epel-release cloud-utils-growpart
