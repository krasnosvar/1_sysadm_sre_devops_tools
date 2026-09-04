# Практические сценарии запуска

Это copy-ready примеры для поддерживаемых утилит репозитория. Команды запускаются
из `1_linux/3_scripts_bash_python`; значения `example`, UUID, bucket, host и
resource ID нужно заменить на свои. Сначала используйте read-only/preview режим.

```bash
cd 1_linux/3_scripts_bash_python
```

## Быстрая диагностика Linux

Проверить место, inode и критичные systemd units перед deploy:

```bash
./bash/host_health.sh -w 80 -c 90 nginx sshd docker
```

Разобрать обычный, rotated или Kubernetes access log:

```bash
./bash/nginx_access_report.sh --top 20 /var/log/nginx/access.log
zcat /var/log/nginx/access.log.*.gz | ./bash/nginx_access_report.sh --top 30
kubectl logs -n ingress-nginx deploy/ingress-nginx-controller \
  | ./bash/nginx_access_report.sh --top 20
```

Повторить только ограниченную и безопасную для повторов команду:

```bash
./bash/retry.sh -a 5 -d 1 -m 15 -- \
  curl --fail --silent --show-error --max-time 5 https://api.example/health
./bash/retry.sh -a 6 -d 2 -m 20 -- \
  kubectl rollout status -n payments deploy/api --timeout=30s
```

Собрать evidence до restart сервиса:

```bash
./bash/service_recovery_guard.sh nginx -- \
  curl --fail --max-time 5 http://127.0.0.1/health
sudo ./bash/service_recovery_guard.sh --apply --grace 5 \
  --output-parent /var/tmp nginx -- \
  curl --fail --max-time 5 http://127.0.0.1/health
```

Подробности: [service recovery guard](bash/service_recovery_guard.md).

## Структурированные файлы и логи

Изменить YAML с автоматической копией `FILE.bak`:

```bash
./python/yaml_set.py values.yaml image.tag v1.4.2
./python/yaml_set.py deployment.yaml spec.template.spec.containers.0.image \
  registry.example/api:v1.4.2
./python/yaml_set.py values.yaml autoscaling.enabled true --create
```

Агрегировать JSON Lines и работать с вложенными полями:

```bash
./python/json_log_summary.py /var/log/myapp/events.jsonl --top 20
./python/json_log_summary.py events.jsonl \
  --level-field severity --message-field event.message --level ERROR --json
journalctl -u myapp -o json \
  | ./python/json_log_summary.py --level-field PRIORITY --message-field MESSAGE
```

Сравнить rendered configurations; значения путей с `password`, `token`,
`secret` и похожими именами скрываются по умолчанию:

```bash
./python/config_diff.py values-production.yaml values-candidate.yaml
./python/config_diff.py deployment-before.json deployment-after.json
```

Переименовать расширения без перезаписи существующих файлов:

```bash
./python/rename_extensions.py /var/tmp/reports --from .jpeg --to .jpg
./python/rename_extensions.py /var/tmp/reports \
  --from .jpeg --to .jpg --recursive --apply
```

Найти literal word или regex и при необходимости получить JSON Lines:

```bash
./python/text_search.py ./deploy deprecated --word \
  --glob '*.yaml' --glob '*.yml'
./python/text_search.py ./deploy 'image:.*:latest$' \
  --regex --glob '*.yaml' --jsonl
./python/text_search.py ./exports password --word --redact-line --jsonl
```

Подробности: [безопасные операции с файлами](python/FILE_OPERATIONS.md).

## OOM, сертификаты и Kubernetes

Разобрать OOM текущей загрузки или сохранённый kernel journal:

```bash
journalctl -k -b -o short-iso | ./python/oom_explain.py
./python/oom_explain.py /var/tmp/kernel-journal.txt --json \
  > /var/tmp/oom-events.json
```

Проверить certificate directories, PKCS#12 и срок 45 дней:

```bash
./python/cert_inventory.py /etc/ssl /opt/myapp --warn-days 45
read -r -s CERT_STORE_PASSWORD
export CERT_STORE_PASSWORD
./python/cert_inventory.py /opt/myapp/client.p12 \
  --password-env CERT_STORE_PASSWORD --json
unset CERT_STORE_PASSWORD
```

Не храните реальный пароль в shell history. В automation загружайте переменную
непосредственно из используемого secret manager.

Понять, почему Pods остаются Pending, либо разобрать заранее снятый snapshot:

```bash
./python/k8s_why_pending.py --context staging --namespace payments
./python/k8s_why_pending.py --namespace payments --pod api-7c9b --json
./python/k8s_why_pending.py --snapshot-dir /var/tmp/pending-snapshot
```

Подробности: [Python diagnostics](python/DIAGNOSTICS.md).

## Параллельная сетевая диагностика на Go

Проверить HTTP(S) и TCP endpoints:

```bash
printf '%s\n' \
  'frontend https://frontend.example/health' \
  'postgres tcp://db.internal.example:5432' \
  | go -C go/endpoint-checker run . -concurrency 8 -timeout 3s -json
```

Проверить TLS certificate с обычным hostname и отдельным SNI:

```bash
printf '%s\n' \
  'api.example' \
  'internal-api 10.20.0.15:443 api.internal.example' \
  | go -C go/tls-expiry-checker run . -warn-days 30 -timeout 5s -json
```

Проверить матрицу hosts × ports с TLS verification на 443:

```bash
printf '%s\n' \
  'api api.internal.example' \
  'database db.internal.example' \
  | go -C go/port-matrix run . \
      -ports 22,443,5432 -tls-ports 443 -concurrency 32 -timeout 2s -json
```

Подробности: [port matrix](go/port-matrix/README.md).

## AWS

Проверить identity перед любым cloud-запуском:

```bash
aws sts get-caller-identity
```

Preview старых S3 objects и отдельное подтверждённое удаление:

```bash
./python/cloud/aws/s3_cleaner.py logs-bucket \
  --prefix application/ --older-than-days 30 --region eu-central-1
./python/cloud/aws/s3_cleaner.py logs-bucket \
  --prefix application/ --older-than-days 30 --region eu-central-1 --apply
```

Preview и изменение power state EC2 только по обязательному tag:

```bash
./python/cloud/aws/ec2_power.py stop \
  --tag Environment=development --region eu-central-1
./python/cloud/aws/ec2_power.py stop \
  --tag Environment=development --region eu-central-1 --apply
```

Найти CloudTrail management events по ресурсу, actor или API operation:

```bash
./python/cloud/aws/who_changed.py \
  --resource-name i-0123456789abcdef0 --region eu-central-1 --hours 24
./python/cloud/aws/who_changed.py \
  --event-name AuthorizeSecurityGroupIngress \
  --region eu-central-1 --hours 6 --json
```

Подробности: [AWS utilities](python/cloud/aws/README.md).

## GCP и Azure

Прочитать Cloud Asset history конкретного GCP resource:

```bash
./python/cloud/gcp/asset_change_timeline.py --project example-project \
  --asset //compute.googleapis.com/projects/example-project/zones/europe-west1-b/instances/api
./python/cloud/gcp/asset_change_timeline.py --organization 123456789 \
  --asset //cloudresourcemanager.googleapis.com/projects/example-project \
  --content-type iam-policy --json
```

Прочитать Azure changes по subscription или конкретному resource ID:

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

Подробности: [GCP](python/cloud/gcp/README.md) и
[Azure](python/cloud/azure/README.md).

## Сохранённые integrations

Проверить MinIO buckets/objects через credentials из environment:

```bash
./python/1_script_examples/minio_check.py minio.example
./python/1_script_examples/minio_check.py minio.example \
  --bucket logs --prefix api/ --recursive
```

Перед запуском `MINIO_ACCESS_KEY` и `MINIO_SECRET_KEY` должны быть загружены в
environment из защищённого источника.

Отправить Matrix notification, передав token только через environment:

```bash
printf 'deployment completed\n' \
  | ./python/1_script_examples/matrix/send_message_to_matrix_room.py \
      https://matrix.example '!room:matrix.example'
```

`MATRIX_ACCESS_TOKEN` должен быть заранее загружен в environment.

Сначала проверить PostgreSQL role, затем создать least-privileged login и
записать сгенерированный пароль в новый файл mode `0600`:

```bash
PGSERVICE=production-admin \
  ./python/1_script_examples/postgres/users_postgres.py app_reader
PGSERVICE=production-admin \
  ./python/1_script_examples/postgres/users_postgres.py app_reader \
    --apply --password-output /var/tmp/app_reader.secret
```

Передать stdin в PrivateBin, не помещая содержимое в argv:

```bash
secret-tool lookup service example \
  | ./python/1_script_examples/privatebin.py \
      https://privatebin.example --expiration 1hour --burn
```

Ограниченно-параллельно повторить subprocess без shell/eval:

```bash
./python/1_script_examples/asyncio/shell_10_times.py \
  --count 10 --concurrency 3 -- \
  curl --fail --max-time 5 https://api.example/health
```

Исходные Expect-примеры сохранены. Для новой интерактивной SSH-сессии:

```bash
expect ./expect/ssh-interactive-sudo.exp server.example admin_user
```

Для регулярной automation используйте SSH keys/certificates, а не password
prompts. Описание различий примеров находится в [Expect README](expect/README.md).

## Прямые команды без отдельного скрипта

- [SMART/NVMe и износ SSD](../1_shell_bash_commands/2_disks_mount_lvm_nfs/smartctl.sh);
- [дополнительные практические `grep`/`rg`
  примеры](../1_shell_bash_commands/6_text_manipulation_utils/grep-practical.sh);
- [дополнительные `jq` и `yq` v4 примеры](../1_shell_bash_commands/6_text_manipulation_utils/jq-yq-practical.sh);
- исходные пользовательские [`grep.sh`](../1_shell_bash_commands/6_text_manipulation_utils/grep.sh)
  и [`jq-yq.sh`](../1_shell_bash_commands/6_text_manipulation_utils/jq-yq.sh)
  сохранены отдельно.
