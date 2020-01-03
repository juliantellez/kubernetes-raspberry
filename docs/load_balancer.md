# Load Balancer

There are various ways of [exposing a service to an external IP address](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).


## Deploy a Load Balancer


```
kubectl expose deploy nginx --port 80 --type LoadBalancer
# service/nginx exposed

kubectl get services
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP      10.96.0.1      <none>        443/TCP        3d23h
nginx        LoadBalancer   10.96.99.217   <pending>     80:30309/TCP   2m16s
```

As you can see nginx's external IP is pending. Since our cluster is running on [bare metal](https://en.wikipedia.org/wiki/Bare_machine) we don't have the luxury of provisioning an external load balancer.

This is normally done by allowing kubernetes to automatically create load balancers on your [cloud provider](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/) giving you a single IP address that will forward all traffic to your service. In our case we will be configuring a bare metal load balancer.

## Enter MetalLB

[MetalLB](https://metallb.universe.tf/) is an implementation of network load balancers for bare metal clusters.

### Install

```
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml
```

Let's have a look at what has been created

```
kubectl get all -n metallb-system

# Output

NAME                              READY   STATUS    RESTARTS   AGE
pod/controller-65895b47d4-z77m9   1/1     Running   0          7m59s
pod/speaker-6z55b                 1/1     Running   0          7m59s
pod/speaker-76smb                 1/1     Running   0          7m59s
pod/speaker-mfgc2                 1/1     Running   0          7m59s

NAME                     DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR                 AGE
daemonset.apps/speaker   3         3         3       3            3           beta.kubernetes.io/os=linux   8m

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/controller   1/1     1            1           8m

NAME                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/controller-65895b47d4   1         1         1       8m
```

- namespace: metallb-system
- controller: responsible for address assignments
- speaker: ensures the load balancer can reach to services (deamon set)

## Configure MLLB

The installation manifest does not include any configuration, this is because it can run in [different modes](https://metallb.universe.tf/configuration/).

The easiest deployment is probably the Layer 2 Configuration, which works by responding to [ARP requests](https://en.wikipedia.org/wiki/Address_Resolution_Protocol) and providing the machine's MAC address to clients.

To configure mlb we would need to give it control over the nodes IPs.
Let's find out the nodes IPs.

```
kubectl get nodes -o wide

# Output

NAME         STATUS   ROLES    AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION   CONTAINER-RUNTIME
k8s-master   Ready    master   4d5h   v1.17.0   192.168.0.27   <none>        Raspbian GNU/Linux 10 (buster)   4.19.75-v7l+     docker://19.3.5
k8s-node-1   Ready    <none>   4d4h   v1.17.0   192.168.0.28   <none>        Raspbian GNU/Linux 10 (buster)   4.19.75-v7+      docker://19.3.5
k8s-node-2   Ready    <none>   4d4h   v1.17.0   192.168.0.26   <none>        Raspbian GNU/Linux 10 (buster)   4.19.75-v7l+     docker://19.3.5
```

Apply an IP range to the configuration, 192.168.0.20 to 192.168.1.40 (in this case):

```
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.0.230-192.168.1.250
```

Apply configuration:

```
kubectl apply -f manifests/dev-raspberry/metallb/config.yml

# configmap/config created
```

## Consideration

Debian buster comes with a new way to deal with firewalls using nftables, but kube-proxy and CNIs still need old iptables interface to program firewall rules.

So, we will enable the legacy mode of iptables. and reboot each node.
as an exercise try monitoring the cluster as you reboot each node

```
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo update-alternatives --set arptables /usr/sbin/arptables-legacy
sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy
```

## Create Load Balancer

Let's deploy an nginx service and assign a load balancer to it

```
kubectl run nginx --image=nginx
kubectl expose deploy nginx --port 80 --type LoadBalancer
```

```
kubectl get services

# Output
NAME                 TYPE           CLUSTER-IP   EXTERNAL-IP     PORT(S)        AGE     SELECTOR
service/nginx       LoadBalancer   10.96.4.10   192.168.0.230   80:31885/TCP   15m     run=nginx
```

And there we go! our service is now available to the outside world.
`curl 192.168.0.230`
