# Operational automation

Небольшие утилиты для реальных SysAdmin/SRE/DevOps задач. Это не учебник по
синтаксису: каждая maintained utility имеет CLI help, коды возврата, обработку
ошибок и безопасные defaults.

## Maintained utilities

| Utility | Язык | Задача | Зависимости | Пример |
| --- | --- | --- | --- | --- |
| [`bash/host_health.sh`](bash/host_health.sh) | Bash | Проверить disk/inodes/systemd и вернуть non-zero при проблемах | Linux, `df`, optional `systemctl` | `./bash/host_health.sh -w 80 -c 90 nginx sshd` |
| [`bash/nginx_access_report.sh`](bash/nginx_access_report.sh) | Bash | Потоково показать top HTTP statuses, clients и paths из combined access-log | Bash, `awk`, `sort` | `zcat access.log.1.gz \| ./bash/nginx_access_report.sh --top 20` |
| [`bash/retry.sh`](bash/retry.sh) | Bash | Повторить CLI-команду с ограниченным exponential backoff без `eval` | Bash | `./bash/retry.sh -a 6 -- curl --fail https://example.com/health` |
| [`bash/service_recovery_guard.sh`](bash/service_recovery_guard.sh) | Bash | Собрать systemd evidence и только с `--apply` сделать один restart | Linux, systemd | `./bash/service_recovery_guard.sh nginx -- curl -f http://127.0.0.1/health` |
| [`python/yaml_set.py`](python/yaml_set.py) | Python | Безопасно изменить scalar по dotted path, с backup и atomic replace | Python 3.10+, PyYAML | `./python/yaml_set.py values.yaml image.tag v1.2.3` |
| [`python/json_log_summary.py`](python/json_log_summary.py) | Python | Потоково агрегировать JSONL-логи без загрузки файла в память | Python 3.10+ | `./python/json_log_summary.py app.jsonl --level ERROR --top 20` |
| [`python/config_diff.py`](python/config_diff.py) | Python | Структурно сравнить JSON/YAML с redaction потенциальных secrets | Python 3.10+, PyYAML | `./python/config_diff.py old.yaml new.yaml` |
| [`python/oom_explain.py`](python/oom_explain.py) | Python | Объяснить Linux OOM-killer events и связать их с cgroup/process | Python 3.10+ | `journalctl -k -b \| ./python/oom_explain.py` |
| [`python/cert_inventory.py`](python/cert_inventory.py) | Python | Найти X.509 в PEM/DER/PKCS/JAR и проверить срок/валидность | Python 3.10+, cryptography | `./python/cert_inventory.py /etc/ssl --warn-days 30` |
| [`python/k8s_why_pending.py`](python/k8s_why_pending.py) | Python | Read-only диагностика Pending Pods по Events/PVC/nodes/resources | Python 3.10+, kubectl | `./python/k8s_why_pending.py --namespace payments` |
| [`go/endpoint-checker/`](go/endpoint-checker/) | Go | Параллельно проверить HTTP(S)/TCP endpoints с timeout и JSON output | Go 1.22+ для сборки | `go -C go/endpoint-checker run . -f endpoints.txt` |
| [`go/tls-expiry-checker/`](go/tls-expiry-checker/) | Go | Параллельно проверить TLS chain/SNI и срок сертификатов | Go 1.22+ для сборки | `printf 'api.example.com\n' \| go -C go/tls-expiry-checker run .` |
| [`go/port-matrix/`](go/port-matrix/) | Go | Параллельно проверить матрицу hosts × TCP/TLS ports | Go 1.22+ для сборки | `go -C go/port-matrix run . -f targets.txt -ports 22,443 -tls-ports 443` |
| [`python/cloud/aws/s3_cleaner.py`](python/cloud/aws/s3_cleaner.py) | Python | Найти и, только с `--apply`, удалить старые S3/MinIO objects | Python 3.10+, boto3 | `./python/cloud/aws/s3_cleaner.py logs --prefix app/ --older-than-days 30` |
| [`python/cloud/aws/ec2_power.py`](python/cloud/aws/ec2_power.py) | Python | Preview/start/stop EC2 по обязательному tag filter | Python 3.10+, boto3 | `./python/cloud/aws/ec2_power.py stop --tag Env=development` |
| [`python/cloud/aws/who_changed.py`](python/cloud/aws/who_changed.py) | Python | Найти CloudTrail events «кто изменил ресурс» | Python 3.10+, boto3 | `./python/cloud/aws/who_changed.py --resource-name i-123 --region eu-central-1` |
| [`python/cloud/gcp/asset_change_timeline.py`](python/cloud/gcp/asset_change_timeline.py) | Python | Прочитать историю Cloud Asset для конкретных ресурсов | Python 3.10+, gcloud | `./python/cloud/gcp/asset_change_timeline.py --project demo --asset //...` |
| [`python/cloud/azure/change_timeline.py`](python/cloud/azure/change_timeline.py) | Python | Прочитать Azure Resource Graph change timeline | Python 3.10+, az + resource-graph | `./python/cloud/azure/change_timeline.py --subscription UUID` |
| [`python/1_script_examples/minio_check.py`](python/1_script_examples/minio_check.py) | Python | Инвентаризация MinIO buckets/objects с TLS verification по умолчанию | Python 3.10+, minio | `MINIO_ACCESS_KEY=... MINIO_SECRET_KEY=... ./minio_check.py minio.example` |
| [`python/1_script_examples/matrix/send_message_to_matrix_room.py`](python/1_script_examples/matrix/send_message_to_matrix_room.py) | Python | Отправить Matrix message через HTTPS и Bearer auth | Python 3.10+ | `MATRIX_ACCESS_TOKEN=... ./send_message_to_matrix_room.py URL ROOM MESSAGE` |
| [`python/1_script_examples/postgres/users_postgres.py`](python/1_script_examples/postgres/users_postgres.py) | Python | Preview/create least-privileged PostgreSQL login role; password goes to mode-0600 file | Python 3.10+, psycopg2 | `./users_postgres.py app_reader --apply --password-output ./role.secret` |
| [`python/1_script_examples/privatebin.py`](python/1_script_examples/privatebin.py) | Python | Передать stdin в PrivateBin по HTTPS, не раскрывая содержимое в argv | Python 3.10+, privatebinapi | `printf 'note\n' \| ./privatebin.py https://privatebin.example --burn` |
| [`python/1_script_examples/asyncio/shell_10_times.py`](python/1_script_examples/asyncio/shell_10_times.py) | Python | Ограниченно-параллельный запуск subprocess без shell/eval | Python 3.10+ | `./shell_10_times.py --count 4 --concurrency 2 -- command args` |

## Почему именно эти языки

- Bash используется для короткой оркестрации уже установленных системных CLI.
- Python используется для структурированных файлов и потоковой обработки данных.
- Go используется для сетевого параллелизма и сборки переносимого single binary.

Облачные утилиты разделены по провайдерам в
[`python/cloud/`](python/cloud/): `aws`, `gcp`, `azure` и `multi_cloud`.
Реализованные команды и запланированные кандидаты не смешиваются: полный
приоритетный список локальной, файловой, hardware, сетевой и облачной
диагностики хранится в [`SCRIPT_BACKLOG.md`](SCRIPT_BACKLOG.md).

Практические инструкции по запуску и интерпретации результата:

- [systemd recovery guard](bash/service_recovery_guard.md);
- [OOM, certificate и Pending Pod diagnostics](python/DIAGNOSTICS.md);
- [параллельная матрица TCP/TLS ports](go/port-matrix/README.md);
- [AWS](python/cloud/aws/README.md), [GCP](python/cloud/gcp/README.md) и
  [Azure](python/cloud/azure/README.md).

Декларативные YAML/HCL-конфиги остаются рядом с владеющим ими сервисом в
[`../2_services/`](../2_services/), а глубокие объяснения и упражнения — в
[отдельных knowledgebase](../../what_to_learn/).

## Existing integrations

Существующие Bash- и Python-скрипты сохранены в `bash/script_examples/` и
`python/1_script_examples/`: Kafka, MinIO, PostgreSQL, Matrix, YAML,
HTTP/Kubernetes и другие прикладные заготовки. AWS implementations перенесены в
`python/cloud/aws/`, а старые AWS-пути сохранены как compatibility launchers.
Legacy scripts не считаются учебным материалом и будут последовательно
доводиться до уровня maintained utilities: CLI-параметры, environment-based
auth, dry-run, безопасные defaults и тесты.

`git.sh` и `python/python.sh` — command-reference fragments, а не программы,
которые запускаются целиком. Учебная теория по языкам остаётся в отдельных
репозиториях `3_go_my_knowledgebase` и `4_python_my_knowledgebase`.

Остальные старые integrations сохранены как legacy. Перед запуском их нужно
проверить на placeholders, TLS verification и способ передачи credentials; они
не входят в CI как maintained utilities. Исходные Expect-примеры сохранены без
изменений, а новый [`expect/ssh-interactive-sudo.exp`](expect/ssh-interactive-sudo.exp)
добавлен отдельным файлом. Для постоянной automation предпочтительнее SSH keys.
