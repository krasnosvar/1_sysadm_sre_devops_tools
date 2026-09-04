# Локальная и Kubernetes-диагностика

Здесь описаны поддерживаемые Python-утилиты, которые превращают
неструктурированный или большой вывод в пригодный для автоматизации JSON. Они
ничего не изменяют в системе или кластере.

## Зависимости

```bash
cd 1_linux/3_scripts_bash_python/python
python3 -m venv .venv
. .venv/bin/activate
python -m pip install cryptography
```

`oom_explain.py` использует только Python standard library.
`k8s_why_pending.py` дополнительно требует `kubectl` и уже настроенный context,
если не используется offline snapshot.

Переименование расширений и поиск по дереву файлов вынесены в отдельную
[инструкцию по файловым операциям](FILE_OPERATIONS.md).

## Разбор Linux OOM

[`oom_explain.py`](oom_explain.py) связывает строку `oom-kill:` с последующей
`Killed process`, показывает global/cgroup scope, PID, process, cgroup и
известные memory counters.

```bash
# Текущая загрузка системы
journalctl -k -b -o short-iso | ./oom_explain.py

# Сохранённый журнал и машинный результат
./oom_explain.py /var/tmp/kernel-journal.txt --json > /var/tmp/oom-events.json
```

Коды: `0` — события найдены, `3` — событий нет, `2` — файл прочитать не
удалось. Парсер объясняет только OOM-killer records, присутствующие в исходном
тексте; он не восстанавливает метрики, которые не попали в journal. Если
контекст и `Killed process` разделены необычно большим фрагментом, настройте
`--context-lines`.

## Инвентаризация локальных сертификатов

[`cert_inventory.py`](cert_inventory.py) рекурсивно читает явно переданные
пути, извлекает X.509 из PEM, DER, PKCS#7, PKCS#12 и certificate-like членов
ZIP/JAR. Private keys не печатаются.

```bash
./cert_inventory.py /etc/ssl /opt/app --warn-days 45
./cert_inventory.py /opt/app --warn-days 30 --json > /var/tmp/certificates.json

# Пароль PKCS#12 не попадает в argv
read -r -s CERT_STORE_PASSWORD && export CERT_STORE_PASSWORD
./cert_inventory.py /opt/app/client.p12 --password-env CERT_STORE_PASSWORD
unset CERT_STORE_PASSWORD
```

Статусы: `ok`, `warning`, `expired`, `not-yet-valid`. Коды: `0` — всё в норме,
`1` — найден проблемный сертификат, `2` — хотя бы один input не удалось
разобрать, `3` — сертификаты не найдены. Scan error имеет приоритет над статусом
сертификатов; подробности идут в stderr или поле `errors` JSON.

По умолчанию symlinks не обходятся, а файл или член архива больше 20 MiB
пропускается. Лимит настраивается `--max-file-bytes`. Java JKS не поддерживается;
его нужно предварительно читать штатным `keytool` или экспортировать сертификат
в PEM/PKCS#12.

## Почему Pod остаётся Pending

[`k8s_why_pending.py`](k8s_why_pending.py) читает Pods, Nodes, PVCs и Events и
объясняет распространённые блокировки: scheduling gates, unbound PVC,
недоступные nodes, nodeSelector/taints и нехватку запрошенных CPU/memory.
Scheduler Events выводятся как основное доказательство.

```bash
# Весь кластер или узкий scope
./k8s_why_pending.py --context staging
./k8s_why_pending.py --namespace payments --pod api-7c9b --json

# Offline-анализ без доступа к кластеру
snapshot=/var/tmp/pending-snapshot
mkdir -p "$snapshot"
kubectl get pods -A -o json > "$snapshot/pods.json"
kubectl get nodes -o json > "$snapshot/nodes.json"
kubectl get pvc -A -o json > "$snapshot/pvcs.json"
kubectl get events -A -o json > "$snapshot/events.json"
./k8s_why_pending.py --snapshot-dir "$snapshot"
```

Код `1` означает, что matching Pending Pods найдены, даже если причина понятна;
`0` — таких Pods нет, `2` — input или `kubectl` завершился с ошибкой. На каждый
вызов `kubectl` действуют `--request-timeout` и отдельный process limit
`--command-timeout`.

Утилита не повторяет весь Kubernetes scheduler: pod topology spread, сложные
affinity/anti-affinity, admission webhooks, CSI provisioning и extender logic
нужно подтверждать по `FailedScheduling` Events и scheduler/controller logs.
См. официальную инструкцию Kubernetes
[Debug Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-pods/).
