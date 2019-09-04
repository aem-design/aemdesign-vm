#!/bin/bash -eux

yum -y groupremove development
yum -y clean all
rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?

## Clean out all of the caching dirs
rm -rf /var/cache/* /usr/share/doc/*
