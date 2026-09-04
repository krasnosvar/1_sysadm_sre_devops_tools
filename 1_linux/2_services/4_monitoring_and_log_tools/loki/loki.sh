#!/usr/bin/env bash
# Loki — log aggregation (Grafana stack)
# Push logs via Promtail/alloy/otel-collector; query via logcli or Grafana

# ── Quick start ───────────────────────────────────────────────────────────────
# minimal docker compose: loki + promtail
# https://raw.githubusercontent.com/grafana/loki/main/production/docker-compose.yaml

docker run -d --name loki -p 3100:3100 \
  -v /path/to/loki-config.yml:/etc/loki/local-config.yaml \
  grafana/loki:latest -config.file=/etc/loki/local-config.yaml

# ── logcli ────────────────────────────────────────────────────────────────────
# install: https://github.com/grafana/loki/releases  (binary: logcli)
export LOKI_ADDR="http://localhost:3100"

# list available labels
logcli labels

# list label values
logcli labels app
logcli labels namespace

# tail logs (like tail -f)
logcli query --tail '{app="nginx"}'

# query last 1h
logcli query --since=1h '{app="nginx"}'

# query with time range
logcli query --from="2024-01-15T10:00:00Z" --to="2024-01-15T11:00:00Z" \
  '{namespace="production", app="api"}'

# filter by text (LogQL pipe)
logcli query '{app="nginx"} |= "error"'

# filter by regex
logcli query '{app="nginx"} |~ "5[0-9]{2}"'

# exclude pattern
logcli query '{app="nginx"} != "health"'

# json log parsing
logcli query '{app="api"} | json | level="error"'

# logfmt parsing
logcli query '{app="worker"} | logfmt | duration > 1s'

# count errors per minute (metric query)
logcli query 'sum(rate({app="api"} |= "error" [1m])) by (pod)'

# ── LogQL examples ────────────────────────────────────────────────────────────

# All logs from a namespace in k8s
# {namespace="production"}

# Specific pod
# {namespace="production", pod=~"api-.*"}

# Parse JSON and filter by field
# {app="api"} | json | status_code >= 500

# Top 10 slowest requests
# topk(10, {app="api"} | logfmt | unwrap duration | rate[5m])

# Error rate per app
# sum by(app)(rate({namespace="production"} |= "error" [5m]))

# ── Push logs via API (useful for testing) ────────────────────────────────────
LOKI="http://localhost:3100"
NOW=$(date +%s%N)

curl -s -X POST "$LOKI/loki/api/v1/push" \
  -H 'Content-Type: application/json' \
  -d "{
    \"streams\": [{
      \"stream\": {\"job\": \"test\", \"env\": \"dev\"},
      \"values\": [[\"$NOW\", \"hello from curl\"]]
    }]
  }"

# ── HTTP API ──────────────────────────────────────────────────────────────────
# health check
curl "$LOKI/ready"

# list labels
curl "$LOKI/loki/api/v1/labels"

# list label values
curl "$LOKI/loki/api/v1/label/app/values"

# query logs
curl -G "$LOKI/loki/api/v1/query_range" \
  --data-urlencode 'query={app="nginx"}' \
  --data-urlencode "start=$(date -d '1 hour ago' +%s)000000000" \
  --data-urlencode "end=$(date +%s)000000000" \
  --data-urlencode 'limit=100' | jq '.data.result[].values[]'
