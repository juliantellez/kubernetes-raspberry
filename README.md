# Kubernetes Raspberry

This repository contains a walk-through of the necessary steps to provision a Raspberry PI Kubernetes cluster.

# Installation
- [Equipment](./docs/equipment.md)
- [Flushing the Operating System](./docs/os_flushing.md)
- [SSH into the Raspberry Pi](./docs/ssh_into_raspberry.md)
- [Manual Installation: Node](./docs/manual_installation/node.md)
- [Manual Installation: Master Node](./docs/manual_installation/node_master.md)
- [Manual Installation: Slave Node](./docs/manual_installation/node_slave.md)


# Getting Started with the cluster
- [Deploy a test service](./docs/getting_started/deploy_service.md)
- [Create a load balancer](./docs/load_balancer.md)
- [Kubernetes Dashboard](./docs/getting_started/dashboard.md)
- [Data Persistence](./docs/data_persistence.md)
- [Observability](./docs/observability.md)
  - [Metrics Collection](./docs/observability/prometheus.md)
  - [Metrics Alerts](./docs/observability/prometheus-alerts.md)

## What's next?
- [Automated Installation: Ansible](./docs/installation/ansible.md)
- [Inspecting the cluster](./docs/getting_started/inspect_cluster.md)
- [Kubectl dive](./docs/getting_started/kubectl.md)
- [Observability](./docs/observability.md)
  - [Logging]()
  - [Tracing]()
- [External DNS]()

## References

- https://www.disasterproject.com/kubernetes-with-external-dns/


### Deployment

- [Deploy a kubernetes ubuntu service](https://www.techrepublic.com/article/how-to-deploy-a-kubernetes-cluster-on-ubuntu-server/)

### CNI

- [Kubernetes Networking model](https://kubernetes.io/docs/concepts/cluster-administration/networking/#the-kubernetes-network-model)
- [Container Network Interface comparison](https://rancher.com/blog/2019/2019-03-21-comparing-kubernetes-cni-providers-flannel-calico-canal-and-weave/)

