#!/bin/bash -eux



systemctl disable docker --now
systemctl enable docker-latest --now
echo #DOCKERBINARY=/usr/bin/docker-latest >>/etc/sysconfig/docker

#cat /etc/sysconfig/docker
sudo echo "### DOCKER LATEST ###" >> /etc/sysconfig/docker
sudo echo "### DOCKER LATEST ###" >> /etc/sysconfig/docker
sed -i "\$aDOCKERBINARY=\/usr\/bin\/docker-latest" /etc/sysconfig/docker
#sudo echo DOCKERBINARY=/usr/bin/docker-latest >> /etc/sysconfig/docker

docker -v
