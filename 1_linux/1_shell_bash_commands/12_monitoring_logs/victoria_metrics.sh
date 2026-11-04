#!/usr/bin/env bash
# VictoriaMetrics — fast, Prometheus-compatible metrics storage
#
# Why VM instead of Prometheus:
#   - 10–20x lower RAM/disk for the same data
#   - built-in long-term retention (years), no Thanos/Cortex needed
#   - compatible with PromQL (+ MetricsQL extensions)
#   - single binary for small setups; cluster mode for large ones
#
# Docs: https://docs.victoriametrics.com/

# ── Single-node quick start ───────────────────────────────────────────────────
docker run -d --name victoriametrics \
  -p 8428:8428 \
  -v /path/to/vm-data:/victoria-metrics-data \
  victoriametrics/victoria-metrics:latest \
  -retentionPeriod=12   # months

VM="http://localhost:8428"

# health / uptime
curl "$VM/health"
curl "$VM/metrics"   # VM's own internal metrics

# ── Ingest data ───────────────────────────────────────────────────────────────

# Prometheus remote_write → VM (in prometheus.yml):
# remote_write:
#   - url: http://victoriametrics:8428/api/v1/write

# push single metric via InfluxDB line protocol
curl -d 'cpu_usage{host="srv1"} 0.42' "$VM/write"

# push via Prometheus text format
cat <<EOF | curl --data-binary @- "$VM/api/v1/import/prometheus"
my_metric{label="a"} 1.0
my_metric{label="b"} 2.0
EOF

# ── Query (PromQL / MetricsQL) ────────────────────────────────────────────────
# VM exposes the same API as Prometheus — drop-in replacement

# instant query
curl -s "$VM/api/v1/query" --data-urlencode 'query=up' | jq '.data.result'

# range query
curl -s "$VM/api/v1/query_range" \
  --data-urlencode 'query=rate(http_requests_total[5m])' \
  --data-urlencode "start=$(date -d '1 hour ago' +%s)" \
  --data-urlencode "end=$(date +%s)" \
  --data-urlencode 'step=60' | jq '.data.result'

# list all metric names
curl -s "$VM/api/v1/label/__name__/values" | jq '.data[]'

# list label values
curl -s "$VM/api/v1/label/job/values" | jq '.data[]'

# ── MetricsQL extras (beyond PromQL) ─────────────────────────────────────────
# These work only in VM (not Prometheus):

# median instead of mean
# median(rate(http_request_duration_seconds[5m]))

# default value when no data (avoids "no data" gaps)
# default(0, rate(http_errors_total[5m]))

# keep last seen value (useful for sparse metrics)
# keep_last_value(temperature{sensor="room"})

# outlier detection — IQR-based anomaly filter
# outliers_iqr(rate(cpu_usage[5m]))

# ── vmctl — data migration / import ──────────────────────────────────────────
# vmctl is a CLI for migrating data between Prometheus/VM instances
# install: https://github.com/VictoriaMetrics/VictoriaMetrics/releases

# migrate from Prometheus to VM
vmctl prometheus \
  --prom-snapshot-path=/path/to/prometheus/data \
  --vm-addr=http://localhost:8428

# migrate between two VM instances
vmctl vm \
  --vm-addr=http://source-vm:8428 \
  --vm-native-dst-addr=http://dest-vm:8428

# ── VictoriaMetrics cluster mode ─────────────────────────────────────────────
# 3 components (separate binaries / pods):
#   vmstorage  — stores raw data, port 8482 (insert) + 8401 (select)
#   vminsert   — receives writes, shards to vmstorage, port 8480
#   vmselect   — handles queries, aggregates from vmstorage, port 8481
#
# Write URL: http://vminsert:8480/insert/0/prometheus/
# Query URL: http://vmselect:8481/select/0/prometheus/
#
# Helm chart: https://github.com/VictoriaMetrics/helm-charts

# ── Grafana datasource for VM ─────────────────────────────────────────────────
# Type: Prometheus
# URL:  http://victoriametrics:8428
# (or for cluster: http://vmselect:8481/select/0/prometheus)
# MetricsQL is understood by Grafana since it's PromQL-compatible
