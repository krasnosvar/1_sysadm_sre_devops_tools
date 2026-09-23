# Backlog прикладных DevOps-утилит

Этот документ сохраняет идеи для следующих реализаций. Он предназначен для
maintainers репозитория и отделяет уже работающие инструменты от roadmap.

Статусы: **готово** означает, что CLI существует и проверяется CI;
**запланировано** означает только согласованный кандидат. Приоритет P0 — высокий,
P1 — следующий, P2 — полезное расширение.

## Правило выбора языка

- Bash — коротко объединить локальные системные команды без сложной модели
  данных.
- Python — разобрать файлы, работать с SDK/API, нормализовать JSON/YAML/CSV и
  формировать отчёты.
- Go — параллельно диагностировать сеть, большое число endpoints, hosts или
  clusters и распространять утилиту одним binary.

## Локальная диагностика Linux

| Приоритет | Кандидат | Язык | Назначение |
| --- | --- | --- | --- |
| готово | [`bash/service_recovery_guard.sh`](bash/service_recovery_guard.sh) | Bash | Read-only health check и evidence; ровно один restart только с `--apply` |
| готово | [`python/oom_explain.py`](python/oom_explain.py) | Python | Связать Linux OOM context с убитым process/cgroup и memory counters |
| P0 | `bash/incident_snapshot.sh` | Bash | Read-only архив: load, memory, disk/inodes, failed units, journal errors, sockets, routes, DNS и container state |
| P0 | `bash/storage_pressure.sh` | Bash | Крупные каталоги, inode exhaustion, deleted-open files, journal и container layers; очистка только отдельным `--apply` |
| P1 | `bash/boot_regression.sh` | Bash | Сравнить текущую загрузку с предыдущей: failed units, kernel errors, boot time и changed devices |
| P1 | `bash/container_host_triage.sh` | Bash | Состояние Docker/Podman, disk usage, unhealthy/restarting containers, cgroups и pressure stalls |
| P1 | `python/process_socket_map.py` | Python | Таблица/JSON `process → PID → cgroup/container → listening/remote sockets` |
| P1 | `python/config_drift.py` | Python | Сравнить файлы с manifest по SHA256, owner, mode и symlink target |
| P1 | `python/log_timeline.py` | Python | Объединить journal JSON и application logs в одну временную шкалу по request/trace ID |
| P2 | `bash/time_sync_triage.sh` | Bash | Проверить chrony/systemd-timesyncd, offset, leap status и доступность NTP peers |
| P2 | `python/package_drift.py` | Python | Сравнить установленные пакеты нескольких hosts с ожидаемым manifest |

## Парсинг и проверка файлов

| Приоритет | Кандидат | Язык | Назначение |
| --- | --- | --- | --- |
| готово | [`python/cert_inventory.py`](python/cert_inventory.py) | Python | Найти X.509 в PEM/DER/PKCS/JAR, показать SAN/fingerprint и проверить validity |
| P0 | `python/config_tree_lint.py` | Python | Рекурсивно валидировать JSON, YAML, TOML и INI; JSON Lines report с путём и ошибкой |
| P0 | `python/env_compare.py` | Python | Сравнить `.env`/environment dumps по именам переменных, маскируя значения потенциальных secrets |
| P1 | `python/file_inventory.py` | Python | Метаданные, SHA256, MIME/type, owner/mode и размер файлов с JSON/CSV output |
| P1 | `python/access_log_correlator.py` | Python | Объединить reverse-proxy/application access logs и агрегировать latency/status/request ID |
| P1 | `python/manifest_query.py` | Python | Извлечь одинаковые paths из множества Kubernetes/Compose/Helm YAML без text grep |
| P1 | `python/jsonl_normalize.py` | Python | Потоково привести разноформатные JSON Lines к выбранной schema без загрузки файла в память |
| P2 | `python/secret_metadata_audit.py` | Python | Найти подозрительные секреты, выводя только путь, строку и тип finding, но не само значение |
| P2 | `python/backup_catalog_verify.py` | Python | Проверить checksums, последовательность и возраст файлов локального backup catalog |

## Проверка оборудования

| Приоритет | Кандидат | Язык | Назначение |
| --- | --- | --- | --- |
| P0 | `bash/hardware_report.sh` | Bash | Единый read-only отчёт lscpu, memory, PCI, block devices, firmware и kernel modules |
| P0 | `bash/disk_health.sh` | Bash | SMART/NVMe health, media errors, temperature, wear, filesystem errors и RAID degradation |
| P1 | `python/hardware_inventory.py` | Python | Нормализовать `lshw`, `dmidecode`, `lsblk --json` и `ip -json` в JSON inventory |
| P1 | `python/numa_irq_audit.py` | Python | NUMA locality, IRQ affinity, NIC queues и потенциально неравномерное распределение CPU |
| P1 | `go/thermal-watch/` | Go | Параллельно снимать температуры/частоты, фиксировать throttling и отдавать JSON Lines |
| P2 | `bash/memory_error_triage.sh` | Bash | EDAC/MCE/kernel reports, ECC counters и признаки OOM без изменения системы |
| P2 | `bash/nic_health.sh` | Bash | Link state, negotiated speed, driver/firmware, error/drop counters и offload flags |

## Сеть и диагностика соединений

| Приоритет | Кандидат | Язык | Назначение |
| --- | --- | --- | --- |
| готово | [`go/endpoint-checker/`](go/endpoint-checker/) | Go | Параллельные HTTP(S)/TCP probes с timeout и JSON output |
| готово | [`go/tls-expiry-checker/`](go/tls-expiry-checker/) | Go | Параллельная проверка TLS chain, SNI и срока сертификатов |
| готово | [`go/port-matrix/`](go/port-matrix/) | Go | Ограниченно-параллельная матрица hosts × TCP/TLS ports с machine output |
| P0 | `go/dns-checker/` | Go | Сравнить ответы нескольких resolvers: A/AAAA/CNAME, TTL, latency, NXDOMAIN и inconsistency |
| P0 | `go/network-path-checker/` | Go | Один report по DNS, TCP connect, TLS handshake, HTTP response и latency каждого endpoint |
| P1 | `bash/mtu_path_triage.sh` | Bash | Найти MTU/fragmentation проблему через `ip route`, tracepath и bounded ping probes |
| P1 | `bash/proxy_chain_triage.sh` | Bash | Диагностировать DNS, proxy variables, CONNECT, certificate chain и конечный HTTP response |
| P1 | `python/packet_summary.py` | Python | Прочитать pcap через tshark JSON и агрегировать retransmits, resets, DNS failures и top flows |
| P2 | `python/socket_leak_report.py` | Python | Найти процессы с ростом sockets, CLOSE_WAIT/TIME_WAIT и исчерпанием ephemeral ports |

## Параллельная диагностика инфраструктуры

| Приоритет | Кандидат | Язык | Назначение |
| --- | --- | --- | --- |
| P0 | `go/fleet-probe/` | Go | Параллельно выполнить фиксированный read-only набор SSH probes на hosts с bounded concurrency |
| P0 | `go/dns-matrix/` | Go | Проверить набор names через набор resolvers и показать расхождения матрицей/JSON |
| P1 | `go/multi-region-latency/` | Go | Сравнить DNS/TCP/TLS/HTTP latency endpoints по регионам и сохранить машинный отчёт |
| P1 | `go/log-stream-sampler/` | Go | Ограниченно-параллельно читать несколько log streams и объединять события по времени |
| P2 | `go/registry-probe/` | Go | Проверить auth, manifest/head и latency нескольких OCI registries без скачивания layers |

## Kubernetes

| Приоритет | Кандидат | Язык | Назначение |
| --- | --- | --- | --- |
| готово | [`python/k8s_why_pending.py`](python/k8s_why_pending.py) | Python | Объяснить Pending Pods по Events, scheduling gates, PVC, nodes, selectors, taints и resource requests |
| P0 | `python/k8s_snapshot.py` | Python | Сохранить минимальный обезличиваемый JSON snapshot для offline incident analysis |
| P1 | `python/k8s_rollout_timeline.py` | Python | Связать ReplicaSet/Pod Events, image changes, probes и restarts в rollout timeline |
| P1 | `go/kubernetes-workload-probe/` | Go | Параллельно проверить readiness/endpoints выбранных workloads в нескольких clusters |

## AWS

Реализованный код находится в [`python/cloud/aws/`](python/cloud/aws/).

| Приоритет | Кандидат | Назначение |
| --- | --- | --- |
| готово | [`who_changed.py`](python/cloud/aws/who_changed.py) | Региональная CloudTrail timeline по одному lookup attribute с bounded scan |
| P0 | `aws_orphan_audit.py` | Unattached EBS, unused Elastic IP, stale snapshot/AMI, empty load balancer и stopped EC2 |
| P0 | `aws_public_exposure.py` | Открытые Security Groups, public RDS/S3/EC2 и internet-facing load balancers |
| P0 | `aws_iam_audit.py` | Старые access keys, MFA gaps, wildcard policies и опасные cross-account trust policies |
| P1 | `aws_inventory.py` | Multi-account/multi-region inventory с tags и JSON/CSV output |
| P1 | `aws_backup_coverage.py` | Ресурсы без backup policy и слишком старые recovery points |
| P1 | `aws_route_explain.py` | Объяснить маршрут subnet → route table → NAT/IGW/TGW → security controls |
| P1 | `aws_eks_readiness.py` | Versions, node health, add-ons, public endpoint и upgrade blockers |
| P1 | `go/aws-cloudwatch-tail/` | Параллельно читать log groups/streams, корректно обрабатывая throttling |

## GCP

Реализованный и будущий код размещается в
[`python/cloud/gcp/`](python/cloud/gcp/).

| Приоритет | Кандидат | Назначение |
| --- | --- | --- |
| готово | [`asset_change_timeline.py`](python/cloud/gcp/asset_change_timeline.py) | История Cloud Asset для явно указанных resources в project/organization scope |
| P0 | `gcp_orphan_audit.py` | Unattached disks, reserved IP, stale snapshots/images и forwarding rules без backend |
| P0 | `gcp_public_exposure.py` | Открытые firewall rules, public buckets/Cloud SQL и exposed GKE control planes |
| P0 | `gcp_iam_audit.py` | User-managed service-account keys, primitive roles и external principals |
| P1 | `gcp_inventory.py` | Inventory по folders/projects/regions с labels и JSON/CSV output |
| P1 | `gcp_backup_coverage.py` | Coverage snapshot/backup policies и возраст recovery points |
| P1 | `gcp_gke_readiness.py` | Versions, node pools, release channels и upgrade blockers |
| P2 | `go/gcp-log-tail/` | Параллельно читать Cloud Logging из нескольких projects/services |

## Azure

Реализованный и будущий код размещается в
[`python/cloud/azure/`](python/cloud/azure/).

| Приоритет | Кандидат | Назначение |
| --- | --- | --- |
| готово | [`change_timeline.py`](python/cloud/azure/change_timeline.py) | Resource Graph `resourcechanges` timeline по явным subscriptions/resource ID |
| P0 | `azure_orphan_audit.py` | Unattached disks/NIC, unused Public IP, stale snapshots и empty load balancers |
| P0 | `azure_public_exposure.py` | Опасные NSG rules, public databases/storage и exposed AKS API endpoints |
| P0 | `azure_identity_audit.py` | Широкие role assignments, Owner scope и истекающие application credentials |
| P1 | `azure_inventory.py` | Inventory по tenants/subscriptions/resource groups с tags и JSON/CSV output |
| P1 | `azure_backup_coverage.py` | Resources без recovery policy и устаревшие restore points |
| P1 | `azure_aks_readiness.py` | Versions, node pools, identities, network mode и upgrade blockers |
| P2 | `go/azure-monitor-tail/` | Параллельно читать Azure Monitor/Log Analytics workspaces |

## Multi-cloud

Будущие implementations размещаются в
[`python/cloud/multi_cloud/`](python/cloud/multi_cloud/).

| Приоритет | Кандидат | Назначение |
| --- | --- | --- |
| P0 | `tag_policy_audit.py` | Общая проверка owner/environment/cost-center/expiration tags или labels |
| P0 | `ttl_janitor.py` | Найти просроченные временные ресурсы; удаление только с provider-specific `--apply` |
| P1 | `public_exposure_report.py` | Нормализовать findings AWS/GCP/Azure без потери provider-specific evidence |
| P1 | `backup_restore_audit.py` | Проверить наличие backup и дату последнего подтверждённого restore test |
| P1 | `identity_expiry_report.py` | Свести сроки ключей, credentials и application secrets нескольких облаков |
| P2 | `region_service_inventory.py` | Сравнить используемые сервисы и регионы между accounts/projects/subscriptions |

## Definition of done

Новый пункт становится **готово**, только когда у него есть:

- `--help`, документированные exit codes и примеры с placeholders;
- read-only default, timeout и bounded concurrency, где это применимо;
- JSON/JSON Lines output для дальнейшей автоматизации;
- обработка pagination, partial failures и API throttling;
- unit tests для parsing/decision logic и smoke test в CI;
- отсутствие credentials в argv, URL, source code и обычном output;
- отдельное подтверждение `--apply` для любых изменений.
