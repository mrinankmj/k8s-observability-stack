# k8s-observability-stack

Metrics, logs, dashboards and SLO-based alerting for Kubernetes, all running locally on kind.

## Stack
Prometheus Operator (kube-prometheus-stack) · Grafana · Loki + Promtail · Alertmanager · k6

## What's included
- **ServiceMonitor** auto-discovers the demo app's metrics.
- **SLO alerts**: error ratio > 1% and p95 latency > 300ms, each linked to a **runbook**.
- **Golden-signals dashboard** provisioned as code (ConfigMap + Grafana sidecar).
- **Loki** log aggregation, queryable from Grafana.
- **k6 load test** that injects ~5% errors so you can watch the alerts fire.

## Run it
Prereqs: Docker, kind, kubectl, Helm, k6.

```bash
make cluster install demo
make grafana      # http://localhost:3000  (admin / admin)
make load         # generate traffic in another terminal
make down
```

## Screenshots
_Add your Grafana dashboard and firing-alert screenshots here._
