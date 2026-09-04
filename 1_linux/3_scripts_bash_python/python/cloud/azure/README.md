# Azure operational utilities

[`change_timeline.py`](change_timeline.py) читает Azure Resource Graph table
`resourcechanges` через штатный Azure CLI. Python SDK не требуется; используется
активная `az login` session.

## Подготовка и запуск

```bash
cd 1_linux/3_scripts_bash_python/python/cloud/azure
az login
az extension add --name resource-graph

./change_timeline.py \
  --subscription 00000000-0000-0000-0000-000000000000

./change_timeline.py \
  --subscription 00000000-0000-0000-0000-000000000000 \
  --resource-id /subscriptions/.../providers/Microsoft.Compute/virtualMachines/api \
  --hours 6 --json
```

Можно повторить `--subscription` для нескольких subscriptions. Команда
read-only; `--details` добавляет changed properties и поэтому может заметно
увеличить report. `--limit` ограничен диапазоном 1–1000.

Коды возврата: `0` — изменения найдены, `3` — изменений нет, `2` — неверный
input, локальная ошибка или ошибка `az`. Скрипт сознательно ограничивает окно
14 днями — это retention Resource Graph change records. Нужны права чтения
выбранных ресурсов и доступ к Resource Graph. Поля и примеры запросов описаны в
[Azure Resource Graph changes](https://learn.microsoft.com/en-us/azure/governance/resource-graph/changes/get-resource-changes).

Остальные кандидаты — orphan/public exposure/identity audits и inventory — пока
только roadmap в [`../../../SCRIPT_BACKLOG.md`](../../../SCRIPT_BACKLOG.md).
