# Runbook

## High error rate
**Alert:** `PodinfoHighErrorRate` (error ratio > 1% for 5m)

1. Check recent deploys: `kubectl -n demo rollout history deploy/podinfo`
2. Inspect logs in Grafana → Explore → Loki: `{namespace="demo"} |= "error"`
3. Check pod health: `kubectl -n demo get pods`, looking for restarts or OOMKilled.
4. If a bad release caused it: `kubectl -n demo rollout undo deploy/podinfo`

## High latency
**Alert:** `PodinfoHighLatencyP95` (p95 > 300ms for 10m)

1. Check the CPU panel for throttling or saturation.
2. Scale out: `kubectl -n demo scale deploy/podinfo --replicas=4`
3. Review resource limits if CPU is pinned at the limit.
