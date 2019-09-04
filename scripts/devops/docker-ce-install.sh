#!/bin/bash -eux


sudo su -

groupadd docker

usermod -aG docker aemdesign

yum remove \
    docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-selinux \
    docker-engine-selinux \
    docker-engine

yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce


pvcreate /dev/sdb
vgcreate docker /dev/sdb
lvcreate --wipesignatures y -n thinpool docker -l 95%VG
lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG
#lvconvert -y \
#--zero n \
#-c 512K \
#--thinpool docker/thinpool \
#--poolmetadata docker/thinpoolmeta
#
#
#sudo cat  > /etc/lvm/profile/docker-thinpool.profile <<EOL
#activation {
#  thin_pool_autoextend_threshold=80
#  thin_pool_autoextend_percent=20
#}
#EOL
#
#lvchange --metadataprofile docker-thinpool docker/thinpool
#lvs -o+seg_monitor
#mkdir /var/lib/docker.bk
#mv /var/lib/docker/* /var/lib/docker.bk

mkdir -p /etc/docker/ && touch /etc/docker/daemon.json

sudo cat  > /etc/docker/daemon.json <<EOL
{
    "storage-driver": "devicemapper",
    "storage-opts": [
    "dm.directlvm_device=/dev/sdb",
    "dm.basesize=5G",
    "dm.thinp_percent=95",
    "dm.thinp_metapercent=1",
    "dm.thinp_autoextend_threshold=80",
    "dm.thinp_autoextend_percent=20",
    "dm.directlvm_device_force=true"
    "dm.thinpooldev=/dev/mapper/docker-thinpool",
    "dm.use_deferred_removal=true",
    "dm.use_deferred_deletion=true"
    ]
}
EOL

#rm -rf /var/lib/docker.bk


service docker start
service docker status
docker info

#sysctl net.bridge.bridge-nf-call-iptables=1
#sysctl net.bridge.bridge-nf-call-ip6tables=1

