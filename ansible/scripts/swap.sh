#!/bin/sh

echo "[ SWAP ] DISABLE"
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
