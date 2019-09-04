#!/bin/bash -eux

sudo su -

groupadd docker

usermod -aG docker aemdesign

yum -y install docker docker-latest

#df -ah
#lsblk
#lvs -av
#pvs -av
#vgs -av

echo DEVS="/dev/sdb">/etc/sysconfig/docker-storage-setup
echo VG=dockervg >> /etc/sysconfig/docker-storage-setup
echo SETUP_LVM_THIN_POOL=yes >> /etc/sysconfig/docker-storage-setup
echo GROWPART=true >> /etc/sysconfig/docker-storage-setup
echo AUTO_EXTEND_POOL=yes >> /etc/sysconfig/docker-storage-setup
echo POOL_AUTOEXTEND_THRESHOLD=70 >> /etc/sysconfig/docker-storage-setup
echo POOL_AUTOEXTEND_PERCENT=20 >> /etc/sysconfig/docker-storage-setup


systemctl enable docker-storage-setup
systemctl enable docker.service


systemctl start docker-storage-setup
systemctl start docker.service

#echo "systemctl status docker-storage-setup.service"
#systemctl status docker-storage-setup.service
#
#echo "journalctl -xe"
#journalctl -xe