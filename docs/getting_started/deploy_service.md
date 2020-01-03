# Deploy a Test service

This section makes the assumption that you already have a kubernetes cluster up and running.

## Install kubectl

[Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) is a cli that runs commands against a kubernetes cluster.

```
brew install kubectl
kubectl version # to verify installation
```

kubectl reads from a dedicated directory called ".kube", more on that later.
This directory was created in the master node on creation.
For Testing purposes we will copy the this folder to our working machine.

```
cd $HOME
MASTER_NODE=192.168.0.27
scp -r pi@$MASTER_NODE:/home/pi/.kube/ .
```

**Note** that you wouldn't do this in a prod environment and a [authentication strategy](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens) would need to be established.

Let's verify that we can access our cluster from our working machine.

```
kubectl get nodes

NAME         STATUS   ROLES    AGE     VERSION
k8s-master   Ready    master   7h14m   v1.17.0
k8s-node-1   Ready    <none>   4h30m   v1.17.0
k8s-node-2   Ready    <none>   4h2m    v1.17.0
```

## Deploy Service

We will be deploying a simple nginx service.

```
kubectl run nginx --image=nginx
kubectl get all

# Output
NAME                         READY   STATUS    RESTARTS   AGE
pod/nginx-6db489d4b7-pmp8c   1/1     Running   0          3d22h

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d22h

NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx   1/1     1            1           3d22h

NAME                               DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-6db489d4b7   1         1         1       3d22h
```

Our service is now up and running but unavailable to the outside world. See the [load balancer](../load_balancer.md) section to find out how to expose services on to an external IP address
