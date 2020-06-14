## Prometheus Alerts

Prometheus alerts are comprised of two parts:

- Alert rules, hold in the prometheus configuration.
- Alert Manager, responsible for alert classification and communication

### [Alert rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)

Prometheus supports two types of rules Alerting and Recording. To include these rules we would need to create a file with the rule statements and load it via the `rule_files` in the prometheus configuration.

To load them we would need to:

- Create the config.

```
# test.alerts.yml

groups:
  - name: example
    rules:
      - alert: DeadMansSwitch
        annotations:
          description:
            This is a DeadMansSwitch meant to ensure that the entire Alerting
            pipeline is functional.
          summary: Alerting DeadMansSwitch
        expr: vector(1)
        labels:
          severity: none
```

- Create a configMap to mount this configuration via volume

```
# kustomazation.yml

configMapGenerator:
  - name: prometheus-alert-etcd
    files:
      - example.alerts.yml=./alerts/example.alerts.yml
```

- Add the volume to the deployment

```
# deployment.yml

volumeMounts:
  - name: prometheus-alert-etcd
    mountPath: /etc/alerts/example.alerts.yml
    subPath: example.alerts.yml
```

- Load the config file to prometheus

```
# resources/prometheus-config.yml

rule_files:
  - "/etc/alerts/*.yml"

```

### [Alert Manager](https://prometheus.io/docs/alerting/alertmanager/)

The Prometheus [alert manager](https://github.com/prometheus/alertmanager) handles deduplication, grouping and routing of events to the correct receiver such as email, [pagerduty](https://www.pagerduty.com/), [opsgenie](https://www.atlassian.com/software/opsgenie), etc..

We will use a kustomization arrangement to provision:

- Alert rules
- Alert configuration
- Deployment and Service


```
kubectl apply -k manifests/dev-raspberry/metrics
```

Note that the alert manager configuration would need a custom receiver, you can use [test webhooks](https://webhook.site/) to test the integration in the meantime.

```
# prometheus-alerts/resources/alertmanager.yml

global:
  resolve_timeout: 5m

  route:
  group_by: ["alertname"]
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: "test-receiver"

receivers:
  - name: "test-receiver"
    webhook_configs:
      - url: "https://webhook.site/<uuid>"
```

You would also need to update the prometheus configuration so it is aware of the alert manager service.

```
# prometheus/resources/prometheus-config.yml

alerting:
  alertmanagers:
    - scheme: http
      static_configs:
      - targets:
        - "prometheus-alerts:9093"
```
