#!/bin/bash -eux

sudo su -

## base rules
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP

# dns
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

function openPort() {
    local PORT=${1?Need port}
    local COMMENT=${2?Need comment}

    iptables -A INPUT -p tcp -m tcp --dport $PORT -m comment --comment "$COMMENT" -j ACCEPT

}

function openPorts() {
    local PORTS=${1?Need ports}
    local COMMENT=${2?Need comment}

    iptables -A INPUT -p tcp -m multiport --dports $PORTS -m comment --comment "$COMMENT" -j ACCEPT

}

function forwardInterface() {
    local FROM=${1?Need from}
    local TO=${2?Need to}
    local COMMENT=${3?Need comment}

    iptables -A FORWARD -i $FROM -o $TO -m comment --comment "$COMMENT" -j ACCEPT
    iptables -A FORWARD -i $TO -o $FROM -m comment --comment "$COMMENT" -j ACCEPT

}
## open ports

#ssh
openPort 22 "service_ssh_port"
#http
openPort 80 "service_http_port"
##registry
#openPort 5000 "docker_registry_port"
#openPort 5001 "docker_registry_mirror_port"
#openPort 5002 "docker_registry_group_port"
##jenkins
#openPort 8080 "service_jenkins_http_port"
##jenkins agent
#openPort 50000 "service_jenkins_agent_port"
##nexus
#openPort 8081 "service_maven_repository_port"
##cadvisor
#openPort 8082 "service_cadvisor_port"
##influxdb
#openPort 8083 "service_influxdb_http_port"
#openPort 8086 "service_influxdb_direct_port"
##grafana
#openPort 3000 "service_grafana_port"
#
##aem
#openPort 4502 "service_author_port"
#openPort 58242 "service_author_debug_port"
#openPort 4503 "service_publish_port"
#openPort 58243 "service_publish_debug_port"
#
##consul
#openPort 53 "service_consul_dns_port"
#openPort 8300 "service_consul_server_port"
#openPort 8301 "service_consul_serf_lan_port"
#openPort 8302 "service_consul_serf_wan_port"
#openPort 8500 "service_consul_http_port"
#openPort 8400 "service_consul_https_port"
#openPort 2375 "service_consul_advertise_port"
#
##selenium hub
#openPort 4444 "service_selenium_grid_port"
#openPort 5555 "service_selenium_hub_port"

# ping
iptables -A INPUT -p icmp -j ACCEPT

#docker
#if [ ! -z "$VM_NET1_IP" ]; then
#    forwardInterface "docker0" "eth0" "docker0-eth0"
#fi
#if [ ! -z "$VM_NET2_IP" ]; then
#    forwardInterface "docker0" "eth1" "docker0-eth1"
#fi
#if [ ! -z "$VM_NET2_IP" ]; then
#    forwardInterface "docker0" "eth2" "docker0-eth2"
#fi

# save rules
iptables-save | tee /etc/sysconfig/iptables

#force restarting iptables for rules to take effect after reboot
set +e
(crontab -l ; echo "@reboot /bin/systemctl restart  iptables.service") | crontab
(crontab -l ; echo "@reboot /bin/systemctl restart  docker.service") | crontab
