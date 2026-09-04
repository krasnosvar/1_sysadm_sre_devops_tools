# AWS operational utilities

Утилиты используют стандартную `boto3` credential chain: environment, AWS
profile, SSO/role credentials или instance identity. Ключи доступа в код и
аргументы CLI не передаются.

## Реализовано

- [`s3_cleaner.py`](s3_cleaner.py) — выводит S3-объекты старше retention
  threshold и удаляет их только с `--apply`.
- [`ec2_power.py`](ec2_power.py) — показывает и запускает/останавливает EC2 по
  обязательному tag filter; изменение требует `--apply`.
- [`who_changed.py`](who_changed.py) — строит read-only timeline последних
  CloudTrail management events по одному lookup attribute.

```bash
cd 1_linux/3_scripts_bash_python/python/cloud/aws
python3 -m pip install boto3

# Read-only preview
./s3_cleaner.py logs-bucket --prefix app/ --older-than-days 30
./ec2_power.py stop --tag Env=development
./who_changed.py --resource-name i-0123456789abcdef0 \
  --region eu-central-1 --hours 24
./who_changed.py --event-name AuthorizeSecurityGroupIngress \
  --region eu-central-1 --hours 6 --json

# Изменение после проверки preview
./s3_cleaner.py logs-bucket --prefix app/ --older-than-days 30 --apply
./ec2_power.py stop --tag Env=development --apply
```

Ожидаемый account и region нужно проверить через `aws sts get-caller-identity`
и AWS profile до запуска с `--apply`. Запланированные audits перечислены в
[`../../../SCRIPT_BACKLOG.md`](../../../SCRIPT_BACKLOG.md).

## Особенности `who_changed.py`

Команда требует ровно один фильтр: resource name/type, event name/source,
username или event ID. Она не изменяет AWS. По умолчанию read-only API events
скрываются; `--include-read-only` возвращает их в результат.

CloudTrail LookupEvents работает отдельно для выбранного Region, хранит lookup
history до 90 дней и принимает только один lookup attribute. `--max-events`
ограничивает результат, а `--max-scanned` — число просмотренных provider events,
что защищает от очень дорогого запроса при фильтрации read-only событий.
Пагинация и AWS throttling обрабатываются SDK с adaptive retry.

Коды возврата: `0` — события найдены, `3` — совпадений нет, `1` — ошибка AWS,
`2` — неверные аргументы. CloudTrail должен быть доступен текущей identity как
минимум через `cloudtrail:LookupEvents`. Ограничения API описаны в
[AWS LookupEvents](https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_LookupEvents.html).
