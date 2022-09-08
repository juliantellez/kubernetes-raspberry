# Manual Installation: Slave Node

Refer to the [node installation](./node.md) first. This section also assumes that you already have a [master node](./node_master.md) up and running.

- [Manual Installation: Slave Node](#manual-installation-slave-node)
- [Join the Cluster](#join-the-cluster)


# Join the Cluster

```
K8S_MASTER_IP=192.168.0.25
sudo kubeadm join $K8S_MASTER_IP:6443 \
    --token <token here> \
    --discovery-token-ca-cert-hash sha256:<hash value here>

# Output: 

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```
