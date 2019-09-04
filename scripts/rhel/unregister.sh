#!/bin/bash -eux

# you still need to remove the system from your classic subscription management
#rm -f /etc/sysconfig/rhn/systemid

# starting from rhel v7
subscription-manager remove --all
subscription-manager unregister
subscription-manager clean
