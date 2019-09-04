#!/bin/bash -eux

sudo su -

#INSTALL RANCHER CONVOY
#curl -#L https://git.io/convoy | sudo bash

FILE=$(curl -L https://github.com/rancher/convoy/releases/latest | grep convoy.tar.gz | sed -n 's/.*href="\([^"]*\).*/\1/p') && echo Downloading $FILE && wget https://github.com$FILE
tar xvf convoy.tar.gz
sudo cp -v convoy/convoy convoy/convoy-pdata_tools /usr/bin/
sudo chmod +x /usr/bin/convoy
sudo chmod +x /usr/bin/convoy-pdata_tools
sudo mkdir -p /etc/docker/plugins/
sudo bash -c 'echo "unix:///var/run/convoy/convoy.sock" > /etc/docker/plugins/convoy.spec'
sudo rm -fr convoy/ convoy.tar.gz

echo $(convoy-pdata_tools)

#make two partitions out of the device
DEVICE=/dev/sdb
wget https://raw.githubusercontent.com/rancher/convoy/master/tools/dm_dev_partition.sh
chmod 700 dm_dev_partition.sh
./dm_dev_partition.sh --write-to-disk $DEVICE
rm -f dm_dev_partition.sh

VFS_PATH=/mnt
DATADEV=/dev/sdb1
METADATADEV=/dev/sdb2

echo "Installing convoy service..."
sudo cat  > /etc/systemd/system/convoy.service <<EOL
[Unit]
Description=Convoy Daemon
Requires=docker.service
[Service]
ExecStart=/usr/bin/convoy daemon --drivers devicemapper --driver-opts dm.datadev=${DATADEV} --driver-opts dm.metadatadev=${METADATADEV}
[Install]
WantedBy=multi-user.target
EOL

#ExecStart=/usr/bin/convoy daemon --drivers vfs --driver-opts vfs.path=${VFS_PATH:/mnt}


systemctl daemon-reload
systemctl enable convoy
systemctl start convoy