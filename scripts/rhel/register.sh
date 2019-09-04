#!/bin/bash -eux

echo "REDHAT REGO: $RHSUB_USER $RHSUB_PASS $RHSUB_POOLID"

subscription-manager register --username=$RHSUB_USER --password=$RHSUB_PASS --auto-attach

subscription-manager repos --enable=rhel-7-server-extras-rpms
subscription-manager repos --enable=rhel-7-server-optional-rpms

yum install -y cloud-init           --enablerepo=rhel-7-server-rh-common-rpms --disableplugin=subscription-manager
yum install -y cloud-utils-growpart --enablerepo=rhel-atomic-host-rpms --disableplugin=subscription-manager


#subscription-manager list --available  #Find pool ID for RHEL subscription
#subscription-manager attach --pool=$RHSUB_POOLID

#subscription-manager list