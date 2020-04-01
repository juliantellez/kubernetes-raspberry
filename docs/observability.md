# Observability

Observability is a measure of how well internal states of a system can be inferred from knowledge of its external outputs. [from wikipedia](https://en.wikipedia.org/wiki/Observability)

Since observability is property of a system, it is therefore our responsibility. We explicitly control the system's **signal emissions** and how these are ingested and stored (**instrumentation**).

- [Observability](#observability)
  - [What are signals?](#what-are-signals)
    - [Metrics](#metrics)
    - [Logs](#logs)
    - [Traces](#traces)
  - [Instrumentation](#instrumentation)
- [Further Reading](#further-reading)

## What are signals?

Signals are metrics, logs and traces emitted by a system.
Broadly speaking you can think of them as:

    - Metrics: What happened
    - Logs: How it happened
    - Traces: Where it happened

### Metrics
Metrics represent a measurement at a point in time for the system They are the primary mechanism for alerting and are used for collecting  `health` and `insights` fed into:

    - Incident management and on-call assignment
    - Postmortem reports
    - Visualization dashboards
    - Historical data

Understanding the state of the system is essential to keeping it available and avoid interruptions to your services. It is our job to set up the right collection and storage of these metrics and wether custom [telemetry](https://en.wikipedia.org/wiki/Telemetry) must be added.

### Logs

Logs represent discrete events. They are usually divided into [sub-categories](https://dzone.com/articles/logging-levels-what-they-are-and-how-they-help-you) such as:

  - `Fatal`: End of the world error, results in someone getting a call at 3AM.
  eg. Service is Unavailable.
  - `Error`: Serious but non-fatal issue, the system's is partially operating. Requires attention sooner than later.
  eg. A dropped database connection.
  - `Warn`: Gray area of hypotheticals. The system has detected an unusual situation. Should be investigated.
  eg. A resource is temporarily unavailable.
  - `Info`: Normal operation records. They provide the skeleton of the issue.
  eg. Service has started, A new user has been added etc...
  - `Debug`: Includes granular information.
  eg. Output some internal state

### Traces

Traces represent a users journey through the entire stack. It is service focused and it aims to identify bottlenecks between dependencies. eg. service A, uses Service B.
Traces give you an insight of:

 - Context propagation
 - Transaction monitoring
 - Root cause analysis
 - Service dependency analysis
 - Performance / latency optimization

## Instrumentation
Instrumentation refers to the instructions you give to the system to emit, store and analyze signals. We are going to be using:

- Metrics: [Prometheus](./observability/prometheus.md)
- Logging: [ELK](./)
- Tracing: [Jaeger](./)

# Further Reading
- https://en.wikipedia.org/wiki/Observability
- https://en.wikipedia.org/wiki/Telemetry
- https://www.sumologic.com/blog/logs-metrics-overview/
- https://dzone.com/articles/logging-levels-what-they-are-and-how-they-help-you
- https://opensource.com/article/19/10/open-source-observability-kubernetes
- https://www.bmc.com/blogs/monitoring-logging-tracing/
- https://github.com/jaegertracing/jaeger
- https://research.google/pubs/pub36356/
