#!/bin/bash -eux

sudo su -

function updateConnection() {
    local NET_ID=${1?Need net current id}
    local NET_NEWID=${2?Need net new id}

    local NET_IP=${3?Need NET_IP}
    local NET_GW=${4?Need NET_GW}
    local NET_DNS=${5?Need NET_DNS}
    local NET_ROUTE1=${6?Need NET_ROUTE1}
    local NET_ROUTE2=${7?Need NET_ROUTE2}

    renameConnection "$NET_ID" "$NET_NEWID"

    sudo nmcli con modify "$NET_NEWID" ipv4.method manual ipv4.addresses $NET_IP
    sudo nmcli con modify "$NET_NEWID" ipv4.gateway $NET_GW
    sudo nmcli con modify "$NET_NEWID" ipv4.dns $NET_DNS
    sudo nmcli con modify "$NET_NEWID" ipv4.routes $NET_ROUTE1
    sudo nmcli con modify "$NET_NEWID" ipv4.routes $NET_ROUTE2
    sudo nmcli con modify "$NET_NEWID" connection.autoconnect yes
#    sudo nmcli con modify "$NET_NEWID" connection.interface-name "$NET_NEWID"
    sudo nmcli con up "$NET_NEWID"
}

function renameConnection() {

    local NET_ID=${1?Need net current id}
    local NET_NEWID=${2?Need net new id}

    sudo nmcli con modify "$NET_ID" connection.id "$NET_NEWID"

}

function setConnectionDefaultStatus() {

    local DEVICE_ID=${1?Need device id}
    local STATUS=${2:-no}

    sudo grep -q "DEFROUTE" /etc/sysconfig/network-scripts/ifcfg-$DEVICE_ID && \
    sudo sed -E -i "s/DEFROUTE\=(.+)/DEFROUTE\=$STATUS/g" /etc/sysconfig/network-scripts/ifcfg-$DEVICE_ID || \
    sudo sed -i "$ a\DEFROUTE\=$STATUS" /etc/sysconfig/network-scripts/ifcfg-$DEVICE_ID

}


#adapter 1: nat - internet connectivity
renameConnection "System enp0s3" "public"
setConnectionDefaultStatus "enp0s3" "yes"
#enp0s3

#adapter 2: hostonly - VM Control
if [ ! -z "$VM_NET1_IP" ]; then

    updateConnection "enp0s8" "vmcontrol" "$VM_NET1_IP" "$VM_NET1_GW" "$VM_NET1_DNS" "$VM_NET1_ROUTE1" "$VM_NET1_ROUTE2"
    setConnectionDefaultStatus "enp0s8" "no"
fi

#adapter 3: host-only - Management
if [ ! -z "$VM_NET2_IP" ]; then

    updateConnection "enp0s9" "management" "$VM_NET2_IP" "$VM_NET2_GW" "$VM_NET2_DNS" "$VM_NET2_ROUTE1" "$VM_NET2_ROUTE2"
    setConnectionDefaultStatus "enp0s9" "no"
fi

#nmcli device status
#nmcli connection show

#df -ah
#lsblk
#lvs -av
#pvs -av
#vgs -av
