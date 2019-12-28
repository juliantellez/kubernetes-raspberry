# Deploy a Test service

This section makes the assumption that you already have a kubernetes cluster up and running.

## Install kubectl

[Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) is a cli that runs commands against a kubernetes cluster.

```
brew install kubectl
kubectl version # to verify installation
```

kubectl reads from a dedicated directory called ".kube",
This directory was created in the master node on creation.
For Testing purposes we will copy the this folder to our working machine.

```
cd $HOME
scp -r pi@192.168.0.27:/home/pi/.kube/ .
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

```
kubectl run nginx --image=nginx
kubectl get pods

NAME                     READY   STATUS    RESTARTS   AGE
nginx-6db489d4b7-pmp8c   1/1     Running   0          24s
```