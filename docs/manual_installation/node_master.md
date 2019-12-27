# Manual Node Master Node

Refer to the [node installation](./node.md) first.

- [Manual Node Master Node](#manual-node-master-node)
  - [Load kubeadm images and init](#load-kubeadm-images-and-init)
  - [Create the Kube config](#create-the-kube-config)
  - [Node Verification](#node-verification)
  - [Install the Kubernetes Network model.](#install-the-kubernetes-network-model)

## Load kubeadm images and init

```
kubeadm config images pull
sudo kubeadm init
```

<p align="center">
    <img src="../../assets/installation_node_master.png" width="500px">
</p>

Save the token and discovery token provided by the initialisation.

```
kubeadm join 192.168.0.27:6443 --token xxx \
    --discovery-token-ca-cert-hash sha256:xxx
```

You can always generate a new token later by doing:

```
KUBE_TOKEN=$(kubeadm token generate)
kubeadm token create $KUBE_TOKEN --print-join-command --ttl=0
```

## Create the Kube config
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## Node Verification
```
pi@k8s-master:~ $ kubectl get nodes
NAME         STATUS     ROLES    AGE   VERSION
k8s-master   NotReady   master   55m   v1.17.0
```

For the node to become ready we need to install a container network.

## Install the Kubernetes Network model.

We won't be creating a network layer since its outside the scope of this project. Instead we would apply one of the widely [available layers](https://kubernetes.io/docs/concepts/cluster-administration/networking/#the-kubernetes-network-model).

```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

You can read more about [flannel here](https://github.com/coreos/flannel).
