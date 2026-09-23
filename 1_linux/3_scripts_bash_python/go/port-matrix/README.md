# Port Matrix

`port-matrix` concurrently checks the Cartesian product of `hosts × ports` with a limited number of workers and a timeout for each pair. This is convenient for testing firewalls, routing, and service exposure from a specific jump host or runner.

## Build and Input

```bash
cd 1_linux/3_scripts_bash_python/go/port-matrix
go build -o port-matrix .

cat > targets.txt <<'EOF'
# NAME HOST
api 10.20.0.15
database db.internal.example
192.0.2.10
EOF
```

A line contains either `HOST` or `NAME HOST`. For IPv6, an address with or without square brackets is allowed. Names are used only as labels in the report.

## Usage

```bash
# Regular TCP connect probes
./port-matrix -f targets.txt -ports 22,5432,9100 \
  -concurrency 32 -timeout 2s

# On 443 additionally check TLS handshake, SNI, and system trust store
./port-matrix -f targets.txt -ports 22,443 -tls-ports 443 -json \
  > port-matrix.json

# Targets can be passed via stdin
printf 'api api.internal.example\n' | ./port-matrix -ports 80,443
```

Each `-tls-ports` must be present in `-ports`. TLS verification is enabled, minimum version is TLS 1.2; there is no flag to disable verification. `-source` sets the label of the point from which the diagnostic is run, for example `bastion-eu-1`.

Code `0` means all probes succeeded, `1` — at least one probe failed or execution was interrupted, `2` — invalid input/output. The error of an individual pair is included in the text/JSON report. The check confirms TCP/TLS availability, but not application protocol readiness; for HTTP use the neighboring [`../endpoint-checker/`](../endpoint-checker/).
