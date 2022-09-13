#!/bin/sh

echo "[ DOCKER ] INTSALL"
sudo curl -sL get.docker.com |  sh
sudo usermod -aG docker ubuntu

sudo tee /etc/docker/daemon.json > /dev/null <<EOT
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOT

echo "[ DOCKER ] RESTART"
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "[ DOCKER ] TEST"
sudo docker run hello-world
