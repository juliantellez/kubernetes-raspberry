#!/bin/sh

echo "[ OS ] UPDATE PACKAGES"
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
