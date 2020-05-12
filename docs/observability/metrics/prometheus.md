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
****
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

In addition to monitoring services you would like to monitor the cluster itself. The scrapping will be performed by the following:

```
kubectl apply -k ./metrics
```

- [Prometheus node exporter](https://github.com/prometheus/node_exporter)
  Exposes Host level metrics, (used as a [deamonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)).

    Examples:

    ```
    node_load1
    node_load5
    node_load15
    node_cpu_seconds_total
    node_memory_MemAvailable_bytes
    node_memory_MemTotal_bytes
    node_memory_Buffers_bytes
    node_memory_SwapCached_bytes
    node_memory_Cached_bytes
    node_memory_MemFree_bytes
    node_memory_SwapFree_bytes
    node_ipvs_incoming_bytes_total
    node_ipvs_incoming_packets_total
    node_ipvs_outgoing_bytes_total
    node_ipvs_outgoing_packets_total
    node_disk_reads_completed_total
    node_disk_writes_completed_total
    node_disk_read_bytes_total
    node_disk_written_bytes_total
    node_filesystem_avail_bytes
    node_filesystem_free_bytes
    node_filesystem_size_bytes
    ```

- [Kube-state-metrics](https://github.com/kubernetes/kube-state-metrics)
    A service that listens to the Kubernetes API server and generates metrics about the state of the objects, including deployments, nodes, and pods.
    For more info about the exposed metrics please see [this link](https://github.com/kubernetes/kube-state-metrics/tree/master/docs#exposed-metrics)

    **Not** available in ARM chips a the moment. See this [issue](https://github.com/kubernetes/kube-state-metrics/issues/1037) if you would like to generate an image to get these metrics going.

    ```
    git clone git@github.com:kubernetes/kube-state-metrics.git
    kubectl apply -k kube-state-metrics/
    ```


    Examples:

  ```
  Daemonsets
    kube_daemonset_status_current_number_scheduled
    kube_daemonset_status_desired_number_scheduled
    kube_daemonset_status_number_misscheduled
    kube_daemonset_status_number_unavailable
    kube_daemonset_metadata_generation

  Deployments
    kube_deployment_metadata_generation
    kube_deployment_spec_paused
    kube_deployment_spec_replicas
    kube_deployment_spec_strategy_rollingupdate_max_unavailable
    kube_deployment_status_observed_generation
    kube_deployment_status_replicas_available
    kube_deployment_status_replicas_unavailable

  Nodes
    kube_node_info
    kube_node_spec_unschedulable
    kube_node_status_allocatable
    kube_node_status_capacity
    kube_node_status_condition

  Pods
    kube_pod_container_info
    kube_pod_container_resource_requests
    kube_pod_container_resource_limits
    kube_pod_container_status_ready
    kube_pod_container_status_terminated_reason
    kube_pod_container_status_waiting_reason
    kube_pod_status_phase
  ```

- [Metrics-server](https://github.com/kubernetes-sigs/metrics-server)
  Collects CPU and memory usage from all nodes served by [kubelet](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)
  
  examples

  ```
  kubelet_docker_operations_errors
  kubelet_docker_operations_latency_microseconds*
  kubelet_running_container_count
  kubelet_running_pod_count
  kubelet_runtime_operations_latency_microseconds*
  ```

- [Cadvisor](https://github.com/google/cadvisor)
  A running daemon that collects, aggregates, processes, and exports information about running containers

  examples

  ```
  container_cpu_load_average_10s
  container_cpu_system_seconds_total
  container_cpu_usage_seconds_total
  container_cpu_cfs_throttled_seconds_total
  container_memory_usage_bytes
  container_memory_swap
  container_spec_memory_limit_bytes
  container_spec_memory_swap_limit_bytes
  container_spec_memory_reservation_limit_bytes
  container_fs_usage_bytes
  container_fs_limit_bytes
  container_fs_writes_bytes_total
  container_fs_reads_bytes_total
  container_network_receive_bytes_total
  container_network_transmit_bytes_total
  container_network_receive_errors_total
  container_network_transmit_errors_total
  ```

# References

- https://sysdig.com/blog/kubernetes-monitoring-prometheus/
- https://help.sumologic.com/Metrics/Kubernetes_Metrics
