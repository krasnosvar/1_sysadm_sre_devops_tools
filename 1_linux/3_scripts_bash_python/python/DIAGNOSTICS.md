# Local and Kubernetes Diagnostics

This section describes supported Python utilities that turn unstructured or large output into automation-friendly JSON. They do not alter anything in the system or cluster.

## Dependencies

```bash
cd 1_linux/3_scripts_bash_python/python
python3 -m venv .venv
. .venv/bin/activate
python -m pip install cryptography
```

`oom_explain.py` uses only the Python standard library.
`k8s_why_pending.py` additionally requires `kubectl` and an already configured context, unless an offline snapshot is used.

## Linux OOM Parsing

[`oom_explain.py`](oom_explain.py) links the `oom-kill:` line with the subsequent `Killed process`, displaying the global/cgroup scope, PID, process, cgroup, and known memory counters.

```bash
# Current system boot
journalctl -k -b -o short-iso | ./oom_explain.py

# Saved journal and machine-readable result
./oom_explain.py /var/tmp/kernel-journal.txt --json > /var/tmp/oom-events.json
```

Exit codes: `0` — events found, `3` — no events, `2` — failed to read file. The parser explains only OOM-killer records present in the source text; it does not recover metrics that did not make it into the journal. If the context and the `Killed process` are separated by an unusually large fragment, adjust `--context-lines`.

## Local Certificate Inventory

[`cert_inventory.py`](cert_inventory.py) recursively reads explicitly passed paths, extracting X.509 from PEM, DER, PKCS#7, PKCS#12, and certificate-like ZIP/JAR members. Private keys are not printed.

```bash
./cert_inventory.py /etc/ssl /opt/app --warn-days 45
./cert_inventory.py /opt/app --warn-days 30 --json > /var/tmp/certificates.json

# PKCS#12 password does not enter argv
read -r -s CERT_STORE_PASSWORD && export CERT_STORE_PASSWORD
./cert_inventory.py /opt/app/client.p12 --password-env CERT_STORE_PASSWORD
unset CERT_STORE_PASSWORD
```

Statuses: `ok`, `warning`, `expired`, `not-yet-valid`. Exit codes: `0` — all good, `1` — problematic certificate found, `2` — at least one input could not be parsed, `3` — no certificates found. A scan error takes precedence over certificate status; details go to stderr or the `errors` JSON field.

By default, symlinks are not followed, and a file or archive member larger than 20 MiB is skipped. The limit can be configured via `--max-file-bytes`. Java JKS is not supported; it must first be read with standard `keytool` or the certificate exported to PEM/PKCS#12.

## Why a Pod Remains Pending

[`k8s_why_pending.py`](k8s_why_pending.py) reads Pods, Nodes, PVCs, and Events, explaining common blockers: scheduling gates, unbound PVC, unavailable nodes, nodeSelector/taints, and insufficient requested CPU/memory. Scheduler Events are output as the primary evidence.

```bash
# Entire cluster or narrow scope
./k8s_why_pending.py --context staging
./k8s_why_pending.py --namespace payments --pod api-7c9b --json

# Offline analysis without cluster access
snapshot=/var/tmp/pending-snapshot
mkdir -p "$snapshot"
kubectl get pods -A -o json > "$snapshot/pods.json"
kubectl get nodes -o json > "$snapshot/nodes.json"
kubectl get pvc -A -o json > "$snapshot/pvcs.json"
kubectl get events -A -o json > "$snapshot/events.json"
./k8s_why_pending.py --snapshot-dir "$snapshot"
```

Exit code `1` means matching Pending Pods were found, even if the cause is clear; `0` — no such Pods, `2` — input or `kubectl` exited with an error. Every `kubectl` call is subject to `--request-timeout` and a separate process limit `--command-timeout`.

The utility does not reimplement the entire Kubernetes scheduler: pod topology spread, complex affinity/anti-affinity, admission webhooks, CSI provisioning, and extender logic must be confirmed via `FailedScheduling` Events and scheduler/controller logs.
See the official Kubernetes guide [Debug Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-pods/).
