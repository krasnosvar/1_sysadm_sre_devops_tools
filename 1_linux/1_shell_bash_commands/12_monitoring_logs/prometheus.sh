#!/usr/bin/env bash
# Prometheus — metrics collection and alerting

# ── Quick start (Docker) ──────────────────────────────────────────────────────
docker run -d --name prometheus -p 9090:9090 \
  -v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus

# ── HTTP API ──────────────────────────────────────────────────────────────────
PROM="http://localhost:9090"

# check health / readiness
curl "$PROM/-/healthy"
curl "$PROM/-/ready"

# reload config without restart
curl -X POST "$PROM/-/reload"

# list all targets and their state
curl -s "$PROM/api/v1/targets" | jq '.data.activeTargets[] | {job:.labels.job, instance:.labels.instance, health:.health}'

# list all series (labels)
curl -s "$PROM/api/v1/label/__name__/values" | jq '.data[]'

# instant query
curl -s "$PROM/api/v1/query" --data-urlencode 'query=up' | jq '.data.result'

# range query (last 1h, step 1m)
curl -s "$PROM/api/v1/query_range" \
  --data-urlencode 'query=rate(http_requests_total[5m])' \
  --data-urlencode "start=$(date -d '1 hour ago' +%s)" \
  --data-urlencode "end=$(date +%s)" \
  --data-urlencode 'step=60' | jq '.data.result'

# list active alerts
curl -s "$PROM/api/v1/alerts" | jq '.data.alerts[] | {name:.labels.alertname, state:.state}'

# list loaded rules
curl -s "$PROM/api/v1/rules" | jq '.data.groups[].rules[] | {name:.name, type:.type}'

# ── PromQL examples ───────────────────────────────────────────────────────────

# CPU usage per core (node_exporter)
# 100 - avg by(instance)(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100

# memory usage %
# (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100

# disk usage %
# (node_filesystem_size_bytes - node_filesystem_free_bytes) / node_filesystem_size_bytes * 100

# HTTP request rate per path
# rate(http_requests_total{job="myapp"}[5m])

# 95th percentile latency (requires histogram metric)
# histogram_quantile(0.95, sum by(le)(rate(http_request_duration_seconds_bucket[5m])))

# error rate %
# rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m]) * 100

# pod restarts in last 15m (k8s)
# increase(kube_pod_container_status_restarts_total[15m]) > 0

# ── Alertmanager ──────────────────────────────────────────────────────────────
AM="http://localhost:9093"

# list active alerts
curl -s "$AM/api/v2/alerts" | jq '.[] | {name:.labels.alertname, state:.status.state}'

# list silences
curl -s "$AM/api/v2/silences" | jq '.[] | {id:.id, comment:.comment, state:.status.state}'

# create silence (1 hour) for a specific alertname
curl -s -X POST "$AM/api/v2/silences" \
  -H 'Content-Type: application/json' \
  -d '{
    "matchers": [{"name":"alertname","value":"HighCPU","isRegex":false}],
    "startsAt": "'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'",
    "endsAt":   "'"$(date -u -d '+1 hour' +%Y-%m-%dT%H:%M:%SZ)"'",
    "comment":  "maintenance window",
    "createdBy": "ops"
  }' | jq '.silenceID'

# delete silence
SILENCE_ID="abc-123"
curl -s -X DELETE "$AM/api/v2/silences/$SILENCE_ID"

# ── node_exporter (quick install) ─────────────────────────────────────────────
# runs on port 9100, exposes host metrics
docker run -d --name node-exporter --net host \
  -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /:/rootfs:ro \
  prom/node-exporter \
  --path.procfs=/host/proc --path.sysfs=/host/sys \
  --collector.filesystem.mount-points-exclude='^/(sys|proc|dev|host|etc)($$|/)' \
  --collector.netclass.ignored-devices='^(veth|br-|docker|lo).*'
