#!/usr/bin/env bash
#echo 'shutdown -P now' > /tmp/shutdown.sh; echo '{{user `ssh_password`}}'|sudo -S sh '/tmp/shutdown.sh'
sudo /usr/sbin/shutdown -P now
#ssh -tt aemdesign@$(hostname) sudo shutdown -P now
