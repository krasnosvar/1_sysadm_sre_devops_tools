#!/usr/bin/env bash
# Distributed tracing — OpenTelemetry, Jaeger, Grafana Tempo
#
# Concepts:
#   trace   — one end-to-end request (tree of spans)
#   span    — one unit of work: service name, operation, duration, tags, logs
#   context — trace-id + span-id propagated via headers (W3C traceparent or B3)

# ═══════════════════════════════════════════════════════════════════════════════
# 1. OpenTelemetry (OTel)
# ═══════════════════════════════════════════════════════════════════════════════
# OTel is the standard: one SDK/protocol for traces, metrics, and logs.
# Apps export via OTLP (gRPC :4317 or HTTP :4318); a Collector fans out to backends.
#
# Docs:  https://opentelemetry.io/docs/
# SDKs:  Go, Python, Java, Node.js, .NET, Rust — all official
#
# Key env vars for auto-instrumentation:
#   OTEL_SERVICE_NAME=my-service
#   OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4318
#   OTEL_TRACES_SAMPLER=parentbased_traceidratio
#   OTEL_TRACES_SAMPLER_ARG=0.1    # sample 10% in production

# OTel Collector — quick start (receives OTLP, exports to Jaeger + Prometheus)
docker run -d --name otel-collector -p 4317:4317 -p 4318:4318 -p 8889:8889 \
  -v /path/to/otel-config.yaml:/etc/otelcol/config.yaml \
  otel/opentelemetry-collector-contrib:latest

# minimal otel-config.yaml:
# receivers:
#   otlp:
#     protocols: {grpc: {endpoint: 0.0.0.0:4317}, http: {endpoint: 0.0.0.0:4318}}
# exporters:
#   otlp/jaeger:
#     endpoint: jaeger:4317
#     tls: {insecure: true}
#   prometheusremotewrite:
#     endpoint: http://prometheus:9090/api/v1/write
# service:
#   pipelines:
#     traces:   {receivers: [otlp], exporters: [otlp/jaeger]}
#     metrics:  {receivers: [otlp], exporters: [prometheusremotewrite]}

# otel-cli — send test spans from the shell (great for CI/shell scripts)
# install: https://github.com/equinix-labs/otel-cli
otel-cli exec --name "my-script" --service "bash" -- ./my_script.sh
otel-cli span --service "bash" --name "manual span" --attrs "env=prod,version=1.2"

# ═══════════════════════════════════════════════════════════════════════════════
# 2. Jaeger
# ═══════════════════════════════════════════════════════════════════════════════
# OSS distributed tracing backed by Cassandra / Elasticsearch / Badger (local).
# UI on :16686, OTLP on :4317/:4318, Thrift HTTP on :14268
#
# Docs: https://www.jaegertracing.io/docs/

# all-in-one (dev/test — in-memory storage)
docker run -d --name jaeger \
  -p 16686:16686 \
  -p 4317:4317 -p 4318:4318 \
  -p 14268:14268 \
  jaegertracing/all-in-one:latest

JAEGER_QUERY="http://localhost:16686"

# list services with traces
curl -s "$JAEGER_QUERY/api/services" | jq '.data[]'

# list operations for a service
curl -s "$JAEGER_QUERY/api/operations?service=my-service" | jq '.data[]'

# find traces (last 1h, limit 20)
curl -s "$JAEGER_QUERY/api/traces" \
  --data-urlencode "service=my-service" \
  --data-urlencode "start=$(date -d '1 hour ago' +%s)000000" \
  --data-urlencode "end=$(date +%s)000000" \
  --data-urlencode "limit=20" | jq '.data[].traceID'

# get specific trace
TRACE_ID="abc123def456"
curl -s "$JAEGER_QUERY/api/traces/$TRACE_ID" | jq '.data[0].spans | length'

# find slow traces (> 500ms)
curl -s "$JAEGER_QUERY/api/traces" \
  --data-urlencode "service=my-service" \
  --data-urlencode "minDuration=500ms" \
  --data-urlencode "limit=10" | jq '.data[].traceID'

# find error traces
curl -s "$JAEGER_QUERY/api/traces" \
  --data-urlencode "service=my-service" \
  --data-urlencode 'tags={"error":"true"}' \
  --data-urlencode "limit=10" | jq '.data[].traceID'

# ═══════════════════════════════════════════════════════════════════════════════
# 3. Grafana Tempo
# ═══════════════════════════════════════════════════════════════════════════════
# Distributed tracing backend from Grafana Labs.
# Cheaper than Jaeger at scale: stores traces in object storage (S3/GCS/Azure).
# No index — search only by trace ID, or via TraceQL, or linked from Loki/Prometheus.
#
# Docs: https://grafana.com/docs/tempo/

docker run -d --name tempo -p 3200:3200 -p 4317:4317 \
  -v /path/to/tempo.yaml:/etc/tempo/tempo.yaml \
  grafana/tempo:latest -config.file=/etc/tempo/tempo.yaml

TEMPO="http://localhost:3200"

# health
curl "$TEMPO/ready"

# get trace by ID
TRACE_ID="abc123"
curl -s "$TEMPO/api/traces/$TRACE_ID" | jq '.'

# search recent traces (last 1h)
curl -s "$TEMPO/api/search" \
  --data-urlencode "start=$(date -d '1 hour ago' +%s)" \
  --data-urlencode "end=$(date +%s)" | jq '.traces[]'

# TraceQL — query traces like PromQL (Tempo ≥ 2.0)
# Find traces with error spans:
#   { status = error }
# Find traces where root span took > 2s:
#   { rootDuration > 2s }
# Find spans from a specific service slower than 500ms:
#   { .service.name = "api" && duration > 500ms }
# Count traces per service:
#   { } | by(.service.name)

curl -s "$TEMPO/api/search" \
  --data-urlencode 'q={ status = error }' \
  --data-urlencode "start=$(date -d '30 minutes ago' +%s)" \
  --data-urlencode "end=$(date +%s)" | jq '.traces[] | {traceID, rootName, durationMs}'

# ═══════════════════════════════════════════════════════════════════════════════
# 4. Zipkin (legacy / simple deployments)
# ═══════════════════════════════════════════════════════════════════════════════
docker run -d --name zipkin -p 9411:9411 openzipkin/zipkin

ZIPKIN="http://localhost:9411"

# list services
curl -s "$ZIPKIN/api/v2/services" | jq '.[]'

# find traces
curl -s "$ZIPKIN/api/v2/traces?serviceName=my-service&limit=10" | jq '.[0][0].traceId'

# ═══════════════════════════════════════════════════════════════════════════════
# 5. Propagation headers (what apps send between services)
# ═══════════════════════════════════════════════════════════════════════════════
# W3C Trace Context (standard, OTel default):
#   traceparent: 00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01
#                   version  trace-id (128bit hex)    span-id (64bit) flags

# B3 (Zipkin legacy, still common):
#   X-B3-TraceId: 4bf92f3577b34da6a3ce929d0e0e4736
#   X-B3-SpanId: 00f067aa0ba902b7
#   X-B3-Sampled: 1

# simulate propagated request for testing
curl -H 'traceparent: 00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01' \
  http://my-service/api/endpoint
