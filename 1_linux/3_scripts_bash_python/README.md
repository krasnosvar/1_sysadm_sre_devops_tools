# Operational automation

Small utilities for real SysAdmin/SRE/DevOps tasks. This is not a syntax tutorial: each maintained utility has CLI help, exit codes, error handling, and safe defaults.

## Maintained utilities

| Utility | Language | Task | Dependencies | Example |
| --- | --- | --- | --- | --- |
| [`bash/host_health.sh`](bash/host_health.sh) | Bash | Check disk/inodes/systemd and return non-zero on issues | Linux, `df`, optional `systemctl` | `./bash/host_health.sh -w 80 -c 90 nginx sshd` |
| [`bash/nginx_access_report.sh`](bash/nginx_access_report.sh) | Bash | Stream top HTTP statuses, clients, and paths from a combined access log | Bash, `awk`, `sort` | `zcat access.log.1.gz \| ./bash/nginx_access_report.sh --top 20` |
| [`bash/retry.sh`](bash/retry.sh) | Bash | Retry a CLI command with bounded exponential backoff without `eval` | Bash | `./bash/retry.sh -a 6 -- curl --fail https://example.com/health` |
| [`bash/service_recovery_guard.sh`](bash/service_recovery_guard.sh) | Bash | Gather systemd evidence and do a single restart only with `--apply` | Linux, systemd | `./bash/service_recovery_guard.sh nginx -- curl -f http://127.0.0.1/health` |
| [`python/yaml_set.py`](python/yaml_set.py) | Python | Safely modify a scalar by dotted path, with backup and atomic replace | Python 3.10+, PyYAML | `./python/yaml_set.py values.yaml image.tag v1.2.3` |
| [`python/json_log_summary.py`](python/json_log_summary.py) | Python | Stream-aggregate JSONL logs without loading the file into memory | Python 3.10+ | `./python/json_log_summary.py app.jsonl --level ERROR --top 20` |
| [`python/config_diff.py`](python/config_diff.py) | Python | Structurally compare JSON/YAML with redaction of potential secrets | Python 3.10+, PyYAML | `./python/config_diff.py old.yaml new.yaml` |
| [`python/oom_explain.py`](python/oom_explain.py) | Python | Explain Linux OOM-killer events and link them to cgroup/process | Python 3.10+ | `journalctl -k -b \| ./python/oom_explain.py` |
| [`python/cert_inventory.py`](python/cert_inventory.py) | Python | Find X.509 in PEM/DER/PKCS/JAR and check expiration/validity | Python 3.10+, cryptography | `./python/cert_inventory.py /etc/ssl --warn-days 30` |
| [`python/k8s_why_pending.py`](python/k8s_why_pending.py) | Python | Read-only diagnostics of Pending Pods by Events/PVC/nodes/resources | Python 3.10+, kubectl | `./python/k8s_why_pending.py --namespace payments` |
| [`go/endpoint-checker/`](go/endpoint-checker/) | Go | Concurrently check HTTP(S)/TCP endpoints with timeout and JSON output | Go 1.22+ to build | `go -C go/endpoint-checker run . -f endpoints.txt` |
| [`go/tls-expiry-checker/`](go/tls-expiry-checker/) | Go | Concurrently check TLS chain/SNI and certificate expiration | Go 1.22+ to build | `printf 'api.example.com\n' \| go -C go/tls-expiry-checker run .` |
| [`go/port-matrix/`](go/port-matrix/) | Go | Concurrently check a matrix of hosts × TCP/TLS ports | Go 1.22+ to build | `go -C go/port-matrix run . -f targets.txt -ports 22,443 -tls-ports 443` |
| [`python/cloud/aws/s3_cleaner.py`](python/cloud/aws/s3_cleaner.py) | Python | Find and, only with `--apply`, delete old S3/MinIO objects | Python 3.10+, boto3 | `./python/cloud/aws/s3_cleaner.py logs --prefix app/ --older-than-days 30` |
| [`python/cloud/aws/ec2_power.py`](python/cloud/aws/ec2_power.py) | Python | Preview/start/stop EC2 by a mandatory tag filter | Python 3.10+, boto3 | `./python/cloud/aws/ec2_power.py stop --tag Env=development` |
| [`python/cloud/aws/who_changed.py`](python/cloud/aws/who_changed.py) | Python | Find CloudTrail events 'who changed the resource' | Python 3.10+, boto3 | `./python/cloud/aws/who_changed.py --resource-name i-123 --region eu-central-1` |
| [`python/cloud/gcp/asset_change_timeline.py`](python/cloud/gcp/asset_change_timeline.py) | Python | Read Cloud Asset history for specific resources | Python 3.10+, gcloud | `./python/cloud/gcp/asset_change_timeline.py --project demo --asset //...` |
| [`python/cloud/azure/change_timeline.py`](python/cloud/azure/change_timeline.py) | Python | Read Azure Resource Graph change timeline | Python 3.10+, az + resource-graph | `./python/cloud/azure/change_timeline.py --subscription UUID` |
| [`python/1_script_examples/minio_check.py`](python/1_script_examples/minio_check.py) | Python | Inventory MinIO buckets/objects with default TLS verification | Python 3.10+, minio | `MINIO_ACCESS_KEY=... MINIO_SECRET_KEY=... ./minio_check.py minio.example` |
| [`python/1_script_examples/matrix/send_message_to_matrix_room.py`](python/1_script_examples/matrix/send_message_to_matrix_room.py) | Python | Send Matrix message via HTTPS and Bearer auth | Python 3.10+ | `MATRIX_ACCESS_TOKEN=... ./send_message_to_matrix_room.py URL ROOM MESSAGE` |
| [`python/1_script_examples/postgres/users_postgres.py`](python/1_script_examples/postgres/users_postgres.py) | Python | Preview/create least-privileged PostgreSQL login role; password goes to mode-0600 file | Python 3.10+, psycopg2 | `./users_postgres.py app_reader --apply --password-output ./role.secret` |
| [`python/1_script_examples/privatebin.py`](python/1_script_examples/privatebin.py) | Python | Pipe stdin to PrivateBin over HTTPS without exposing content in argv | Python 3.10+, privatebinapi | `printf 'note\n' \| ./privatebin.py https://privatebin.example --burn` |
| [`python/1_script_examples/asyncio/shell_10_times.py`](python/1_script_examples/asyncio/shell_10_times.py) | Python | Bounded-concurrent execution of a subprocess without shell/eval | Python 3.10+ | `./shell_10_times.py --count 4 --concurrency 2 -- command args` |

## Why these languages

- Bash is used for short orchestration of already installed system CLIs.
- Python is used for structured files and streaming data processing.
- Go is used for network concurrency and building portable single binaries.

Cloud utilities are divided by providers in
[`python/cloud/`](python/cloud/): `aws`, `gcp`, `azure` and `multi_cloud`.
Implemented commands and planned candidates are not mixed: the full priority list of local, file, hardware, network, and cloud diagnostics is stored in [`SCRIPT_BACKLOG.md`](SCRIPT_BACKLOG.md).

Practical instructions for running and interpreting the output:

- [systemd recovery guard](bash/service_recovery_guard.md);
- [OOM, certificate and Pending Pod diagnostics](python/DIAGNOSTICS.md);
- [parallel TCP/TLS port matrix](go/port-matrix/README.md);
- [AWS](python/cloud/aws/README.md), [GCP](python/cloud/gcp/README.md) and
  [Azure](python/cloud/azure/README.md).

Declarative YAML/HCL configs remain next to the service that owns them in
[`../2_services/`](../2_services/), while deep explanations and exercises are in
[separate knowledgebases](../../what_to_learn/).

## Existing integrations

Existing Bash and Python scripts are saved in `bash/script_examples/` and
`python/1_script_examples/`: Kafka, MinIO, PostgreSQL, Matrix, YAML,
HTTP/Kubernetes, and other application templates. AWS implementations have been moved to `python/cloud/aws/`, and old AWS paths are saved as compatibility launchers.
Legacy scripts are not considered educational material and will gradually be brought up to the level of maintained utilities: CLI parameters, environment-based auth, dry-run, safe defaults, and tests.

`git.sh` and `python/python.sh` are command-reference fragments, not programs meant to be run entirely. Learning theory for languages stays in separate repositories `3_go_my_knowledgebase` and `4_python_my_knowledgebase`.

Other older integrations are preserved as legacy. Before running them, check for placeholders, TLS verification, and the method of passing credentials; they are not part of CI like maintained utilities. The original Expect examples are kept unchanged, and a new [`expect/ssh-interactive-sudo.exp`](expect/ssh-interactive-sudo.exp) is added as a separate file. For permanent automation, SSH keys are preferred over passwords.
