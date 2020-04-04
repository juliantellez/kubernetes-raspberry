# [Prometheus](https://prometheus.io/)

Prometheus offers the following out of the box:

```
  - Instrumentation libraries
  - Storage backend
  - Visualization UI
  - Alerting frameworks
```

- [Prometheus](#prometheus)
  - [What is Prometheus?](#what-is-prometheus)
  - [Installing](#installing)
  - [Scraping metrics from a service](#scraping-metrics-from-a-service)
  - [Scraping metrics from Kubernetes](#scraping-metrics-from-kubernetes)
- [References](#references)

## What is Prometheus?
Prometheus is a systems monitoring toolkit which scrapes endpoints from targets and stores time series data. See the [Prometheus Overview](https://prometheus.io/docs/introduction/overview/).

## Installing

We will define a metrics namespace and use [kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/) to apply the changes. We will include:

- A namespace called metrics
- A prometheus configuration embedded as a configMap. [see readme](https://prometheus.io/docs/prometheus/latest/configuration/configuration/).
- A Deployment with 2 replicas and a configMap volume
- A Service with a load balancer

```
kubectl apply -k ../../manifests/dev-raspberry/metrics

# Output
namespace/metrics created
configmap/prometheus-config-xxx created
service/prometheus created
deployment.apps/prometheus created
```

## Scraping metrics from a service

Services should expose a metrics path, usually `/metrics`. This endpoint is then fed into our [prometheus configuration](../../manifests/dev-raspberry/metrics/prometheus/resources/prometheus-config.yml).

```
- job_name: '<service-name>'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['IP:xxx']
```

Alternatively you can use one of the [exporters](https://prometheus.io/docs/instrumenting/exporters/) available. More on that later.


## Scraping metrics from Kubernetes

In addition to monitoring services you would like to monitor the cluster itself. We would be using the [prometheus node exporter](https://github.com/prometheus/node_exporter) as a [deamonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/).


```
kubectl apply -k ./metrics
```

Kuberenetes provides a [service](https://github.com/kubernetes/kube-state-metrics) that listens to the API server and generates metrics about the state of the objects. Not available in ARM chips a the moment. See this [issue](https://github.com/kubernetes/kube-state-metrics/issues/1037) if you would like to generate an image to get these metrics going.

```
git clone git@github.com:kubernetes/kube-state-metrics.git
kubectl apply -k kube-state-metrics/
```

# References

- https://sysdig.com/blog/kubernetes-monitoring-prometheus/
