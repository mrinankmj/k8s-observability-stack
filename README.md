# k8s-observability-stack

Metrics, logs, dashboards and SLO-based alerting for Kubernetes, all running locally on kind.

## Stack
Prometheus Operator (kube-prometheus-stack) · Grafana · Loki + Promtail · Alertmanager · k6

## What's included
- **ServiceMonitor** auto-discovers the demo app's metrics.
- **SLO alerts**: error ratio > 1%, p95 latency > 300ms, and frequent pod restarts — each linked to a **runbook**.
- **Availability panel**: a live `1 - error_ratio` stat, thresholded at 99% / 99.9%.
- **Golden-signals dashboard** provisioned as code (ConfigMap + Grafana sidecar).
- **Critical alerts reach Slack**: everything else stays on a `null` receiver; the webhook URL is never in git (see below).
- **Loki** log aggregation, queryable from Grafana.
- **k6 load test** that injects ~5% errors so you can watch the alerts fire.

## Run it
Prereqs: Docker, kind, kubectl, Helm, k6.

```bash
make cluster install demo
make grafana         # http://localhost:3000  (admin / admin)
make load            # generate traffic in another terminal
make alerts-secret   # optional: point critical alerts at a real Slack webhook
make down
```

## Slack alerts
`make install` creates a placeholder `alertmanager-slack-webhook` Secret so the
cluster comes up cleanly with no setup. Run `make alerts-secret` any time and
paste a real Slack incoming-webhook URL (or a `webhook.site` test URL) — Alertmanager
hot-reloads the mounted secret automatically, no restart needed. Only alerts
labeled `severity: critical` (currently `PodinfoHighErrorRate`) are routed to Slack.

## Screenshots
_Add your Grafana dashboard and firing-alert screenshots here._
