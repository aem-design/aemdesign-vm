#!/bin/bash -eux
# These were only needed for building VMware/Virtualbox extensions:
yum -y remove gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y clean all
rm -rf /etc/yum.repos.d/{puppetlabs,epel}.repo
rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?


# Remove traces of mac address from network configuration
#sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
#rm /etc/udev/rules.d/70-persistent-net.rules

for ndev in $(ls /etc/sysconfig/network-scripts/ifcfg-*); do
  if [ "$(basename ${ndev})" != "ifcfg-lo" ]; then
    sed -i '/^HWADDR/d' ${ndev}
    sed -i '/^UUID/d' ${ndev}
  fi
done

## Clean out all of the caching dirs
rm -rf /var/cache/* /usr/share/doc/*

# Clean up unused disk space so compressed image is smaller.
#cat /dev/zero > /tmp/zero.fill
#rm /tmp/zero.fill
