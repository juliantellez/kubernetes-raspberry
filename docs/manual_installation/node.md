# Manual Node Installation

The aim of this section is to document how all these pieces fit together, mainly for educational purposes. At this point you should already have two or more raspberry Pis that you can ssh to. Note that the following steps are to be replicated in each of the nodes.

- [Manual Node Installation](#manual-node-installation)
  - [Setup Hostnames and Static IPs](#setup-hostnames-and-static-ips)
  - [Disable swap file](#disable-swap-file)
  - [Edit boot configuration](#edit-boot-configuration)
  - [Install Docker](#install-docker)
  - [Install Kubernetes](#install-kubernetes)
  - [Update and reboot](#update-and-reboot)
  - [Install kubeadm](#install-kubeadm)

## Setup Hostnames and Static IPs

Slave nodes need to provide its unique name to the master node upon registration.

```sh
# On each node
NODE_NAME=k8s-master # k8s-node-1 etc..
sudo hostnamectl set-hostname $NODE_NAME
```

Edit the hosts file so that it maps IP addresses to hostnames. [see this link](../ssh_into_raspberry.md) to find out how to find the nodes' IP addresses.

```sh
sudo nano /etc/hosts

192.168.0.27 k8s-master
192.168.0.28 k8s-node-1
192.168.0.29 k8s-node-2
```

## Disable swap file
Why do we need to disable the swap memory?

```
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo systemctl disable dphys-swapfile
sudo swapoff -a
```

## Edit boot configuration

Append the following config to the boot file.

```
sudo nano /boot/cmdline.txt

ipv6.disable=1 cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1
```

## Install Docker
```
sudo curl -sL get.docker.com |  sh
sudo usermod -aG docker pi

sudo touch /etc/docker/daemon.json
sudo nano /etc/docker/daemon.json

# Append the following json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}


# Restart docker.
sudo systemctl daemon-reload
sudo systemctl restart docker
```

Check that docker is properly installed

```
docker run hello-world
```

## Install Kubernetes
```
# Add the kubernetes repository
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - 
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

## Update and reboot

```
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo reboot -h now
```

## Install kubeadm

```
sudo apt-get install -y kubeadm
```