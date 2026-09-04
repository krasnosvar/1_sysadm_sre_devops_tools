# Monitoring, logging and tracing tools

```
.
├── prometheus
│   └── prometheus.sh       - Prometheus API, PromQL examples, Alertmanager, node_exporter
├── loki
│   └── loki.sh             - logcli commands, LogQL examples, push API
├── tracing
│   └── tracing.sh          - OpenTelemetry, Jaeger, Grafana Tempo, Zipkin, propagation headers
├── victoria_metrics
│   └── vm.sh               - VictoriaMetrics single-node + cluster, MetricsQL, vmctl migration
├── elasticsearch
│   └── elastic_commands.sh - Elasticsearch REST API / cluster commands
└── rsyslog
    ├── log-to-radar.conf   - sample config: ship httpd logs to remote syslog collector
    └── rsyslogd.sh         - rsyslog commands
```

## Metrics

1. [prometheus/prometheus.sh](prometheus/prometheus.sh) — Prometheus HTTP API (targets, rules, alerts), PromQL query examples (CPU/memory/disk/HTTP/latency/error-rate), Alertmanager silence management, node_exporter quickstart
2. [victoria_metrics/vm.sh](victoria_metrics/vm.sh) — drop-in Prometheus replacement with 10-20x lower resource usage; MetricsQL extras, vmctl migration, cluster mode overview

## Logs

1. [loki/loki.sh](loki/loki.sh) — logcli (tail, label discovery, LogQL filters, JSON/logfmt parsing, metric queries), Loki HTTP API, push via curl
2. [elasticsearch/elastic_commands.sh](elasticsearch/elastic_commands.sh) — Elasticsearch REST API / cluster commands
3. [rsyslog](rsyslog) — rsyslog commands and a sample log-forwarding config

## Tracing

1. [tracing/tracing.sh](tracing/tracing.sh) — full tracing stack:
   - **OpenTelemetry (OTel)** — standard SDK/protocol; Collector config, key env vars, otel-cli for shell spans
   - **Jaeger** — all-in-one quickstart, API: service list, trace search, slow/error trace queries
   - **Grafana Tempo** — object-storage backend, TraceQL examples, HTTP API
   - **Zipkin** — legacy API reference
   - **Propagation headers** — W3C `traceparent` and B3 formats explained
