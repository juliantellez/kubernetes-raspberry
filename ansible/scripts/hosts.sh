#!/bin/sh

# Edit this file before running.
# This file should be more dynamic in hindsight :(

echo "[ HOSTS ] ADD NAME"
NODE_NAME=k8s-master
sudo hostnamectl set-hostname $NODE_NAME

#  --append
echo "[ HOSTS ] ADD ALL"
sudo tee /etc/hosts > /dev/null <<EOT
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts

192.168.0.25 k8s-master
192.168.0.28 k8s-node-1
192.168.0.29 k8s-node-2
EOT
