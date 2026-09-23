# Practical Execution Scenarios

These are copy-ready examples for the repository's maintained utilities. Commands should be run from `1_linux/3_scripts_bash_python`; replace the values `example`, UUID, bucket, host, and resource ID with your own. Always use the read-only/preview mode first.

```bash
cd 1_linux/3_scripts_bash_python
```

## Quick Linux Diagnostics

Check space, inodes, and critical systemd units before a deploy:

```bash
./bash/host_health.sh -w 80 -c 90 nginx sshd docker
```

Parse a regular, rotated, or Kubernetes access log:

```bash
./bash/nginx_access_report.sh --top 20 /var/log/nginx/access.log
zcat /var/log/nginx/access.log.*.gz | ./bash/nginx_access_report.sh --top 30
kubectl logs -n ingress-nginx deploy/ingress-nginx-controller \
  | ./bash/nginx_access_report.sh --top 20
```

Retry only a limited and retry-safe command:

```bash
./bash/retry.sh -a 5 -d 1 -m 15 -- \
  curl --fail --silent --show-error --max-time 5 https://api.example/health
./bash/retry.sh -a 6 -d 2 -m 20 -- \
  kubectl rollout status -n payments deploy/api --timeout=30s
```

Gather evidence prior to a service restart:

```bash
./bash/service_recovery_guard.sh nginx -- \
  curl --fail --max-time 5 http://127.0.0.1/health
sudo ./bash/service_recovery_guard.sh --apply --grace 5 \
  --output-parent /var/tmp nginx -- \
  curl --fail --max-time 5 http://127.0.0.1/health
```

Details: [service recovery guard](bash/service_recovery_guard.md).

## Structured Files and Logs

Modify YAML with an automatic `FILE.bak` backup:

```bash
./python/yaml_set.py values.yaml image.tag v1.4.2
./python/yaml_set.py deployment.yaml spec.template.spec.containers.0.image \
  registry.example/api:v1.4.2
./python/yaml_set.py values.yaml autoscaling.enabled true --create
```

Aggregate JSON Lines and work with nested fields:

```bash
./python/json_log_summary.py /var/log/myapp/events.jsonl --top 20
./python/json_log_summary.py events.jsonl \
  --level-field severity --message-field event.message --level ERROR --json
journalctl -u myapp -o json \
  | ./python/json_log_summary.py --level-field PRIORITY --message-field MESSAGE
```

Compare rendered configurations; values of paths with `password`, `token`, `secret`, and similar names are hidden by default:

```bash
./python/config_diff.py values-production.yaml values-candidate.yaml
./python/config_diff.py deployment-before.json deployment-after.json
```

Rename extensions without overwriting existing files:

```bash
./python/rename_extensions.py /var/tmp/reports --from .jpeg --to .jpg
./python/rename_extensions.py /var/tmp/reports \
  --from .jpeg --to .jpg --recursive --apply
```

Find a literal word or regex and optionally output JSON Lines:

```bash
./python/text_search.py ./deploy deprecated --word \
  --glob '*.yaml' --glob '*.yml'
./python/text_search.py ./deploy 'image:.*:latest$' \
  --regex --glob '*.yaml' --jsonl
./python/text_search.py ./exports password --word --redact-line --jsonl
```

Details: [safe file operations](python/FILE_OPERATIONS.md).

## OOM, Certificates, and Kubernetes

Parse the OOM of the current boot or a saved kernel journal:

```bash
journalctl -k -b -o short-iso | ./python/oom_explain.py
./python/oom_explain.py /var/tmp/kernel-journal.txt --json \
  > /var/tmp/oom-events.json
```

Check certificate directories, PKCS#12, and a 45-day expiration threshold:

```bash
./python/cert_inventory.py /etc/ssl /opt/myapp --warn-days 45
read -r -s CERT_STORE_PASSWORD
export CERT_STORE_PASSWORD
./python/cert_inventory.py /opt/myapp/client.p12 \
  --password-env CERT_STORE_PASSWORD --json
unset CERT_STORE_PASSWORD
```

Do not store the real password in your shell history. In automation, load the variable directly from the secret manager in use.

Understand why Pods are remaining Pending, or parse a previously taken snapshot:

```bash
./python/k8s_why_pending.py --context staging --namespace payments
./python/k8s_why_pending.py --namespace payments --pod api-7c9b --json
./python/k8s_why_pending.py --snapshot-dir /var/tmp/pending-snapshot
```

Details: [Python diagnostics](python/DIAGNOSTICS.md).

## Concurrent Network Diagnostics with Go

Check HTTP(S) and TCP endpoints:

```bash
printf '%s\n' \
  'frontend https://frontend.example/health' \
  'postgres tcp://db.internal.example:5432' \
  | go -C go/endpoint-checker run . -concurrency 8 -timeout 3s -json
```

Check TLS certificate with standard hostname and separate SNI:

```bash
printf '%s\n' \
  'api.example' \
  'internal-api 10.20.0.15:443 api.internal.example' \
  | go -C go/tls-expiry-checker run . -warn-days 30 -timeout 5s -json
```

Check a matrix of hosts × ports with TLS verification on 443:

```bash
printf '%s\n' \
  'api api.internal.example' \
  'database db.internal.example' \
  | go -C go/port-matrix run . \
      -ports 22,443,5432 -tls-ports 443 -concurrency 32 -timeout 2s -json
```

Details: [port matrix](go/port-matrix/README.md).

## AWS

Check identity before any cloud run:

```bash
aws sts get-caller-identity
```

Preview old S3 objects and perform a separate confirmed deletion:

```bash
./python/cloud/aws/s3_cleaner.py logs-bucket \
  --prefix application/ --older-than-days 30 --region eu-central-1
./python/cloud/aws/s3_cleaner.py logs-bucket \
  --prefix application/ --older-than-days 30 --region eu-central-1 --apply
```

Preview and alter EC2 power state only via a mandatory tag:

```bash
./python/cloud/aws/ec2_power.py stop \
  --tag Environment=development --region eu-central-1
./python/cloud/aws/ec2_power.py stop \
  --tag Environment=development --region eu-central-1 --apply
```

Find CloudTrail management events by resource, actor, or API operation:

```bash
./python/cloud/aws/who_changed.py \
  --resource-name i-0123456789abcdef0 --region eu-central-1 --hours 24
./python/cloud/aws/who_changed.py \
  --event-name AuthorizeSecurityGroupIngress \
  --region eu-central-1 --hours 6 --json
```

Details: [AWS utilities](python/cloud/aws/README.md).

## GCP and Azure

Read the Cloud Asset history of a specific GCP resource:

```bash
./python/cloud/gcp/asset_change_timeline.py --project example-project \
  --asset //compute.googleapis.com/projects/example-project/zones/europe-west1-b/instances/api
./python/cloud/gcp/asset_change_timeline.py --organization 123456789 \
  --asset //cloudresourcemanager.googleapis.com/projects/example-project \
  --content-type iam-policy --json
```

Read Azure changes by subscription or specific resource ID:

```bash
subscription_id=00000000-0000-0000-0000-000000000000
resource_id="/subscriptions/${subscription_id}/resourceGroups/example"
resource_id="${resource_id}/providers/Microsoft.Compute/virtualMachines/api"
./python/cloud/azure/change_timeline.py \
  --subscription "$subscription_id"
./python/cloud/azure/change_timeline.py \
  --subscription "$subscription_id" --resource-id "$resource_id" \
  --hours 6 --json
```

Details: [GCP](python/cloud/gcp/README.md) and
[Azure](python/cloud/azure/README.md).

## Saved Integrations

Check MinIO buckets/objects using credentials from the environment:

```bash
./python/1_script_examples/minio_check.py minio.example
./python/1_script_examples/minio_check.py minio.example \
  --bucket logs --prefix api/ --recursive
```

Before running, `MINIO_ACCESS_KEY` and `MINIO_SECRET_KEY` must be loaded into the environment from a secure source.

Send a Matrix notification, passing the token solely through the environment:

```bash
printf 'deployment completed\n' \
  | ./python/1_script_examples/matrix/send_message_to_matrix_room.py \
      https://matrix.example '!room:matrix.example'
```

`MATRIX_ACCESS_TOKEN` must be pre-loaded in the environment.

First check a PostgreSQL role, then create a least-privileged login and write the generated password to a new `0600` mode file:

```bash
PGSERVICE=production-admin \
  ./python/1_script_examples/postgres/users_postgres.py app_reader
PGSERVICE=production-admin \
  ./python/1_script_examples/postgres/users_postgres.py app_reader \
    --apply --password-output /var/tmp/app_reader.secret
```

Pipe stdin to PrivateBin without placing the content in argv:

```bash
secret-tool lookup service example \
  | ./python/1_script_examples/privatebin.py \
      https://privatebin.example --expiration 1hour --burn
```

Repeat a subprocess in bounded concurrency without shell/eval:

```bash
./python/1_script_examples/asyncio/shell_10_times.py \
  --count 10 --concurrency 3 -- \
  curl --fail --max-time 5 https://api.example/health
```

The original Expect examples are preserved. For a new interactive SSH session:

```bash
expect ./expect/ssh-interactive-sudo.exp server.example admin_user
```

For regular automation, use SSH keys/certificates rather than password prompts. An explanation of the differences between examples can be found in the [Expect README](expect/README.md).

## Direct Commands Without a Custom Script

- [SMART/NVMe and SSD wear](../1_shell_bash_commands/2_disks_mount_lvm_nfs/smartctl.sh);
- [Additional practical `grep`/`rg` examples](../1_shell_bash_commands/6_text_manipulation_utils/grep-practical.sh);
- [Additional `jq` and `yq` v4 examples](../1_shell_bash_commands/6_text_manipulation_utils/jq-yq-practical.sh);
- The original user [`grep.sh`](../1_shell_bash_commands/6_text_manipulation_utils/grep.sh) and [`jq-yq.sh`](../1_shell_bash_commands/6_text_manipulation_utils/jq-yq.sh) are kept separately.
