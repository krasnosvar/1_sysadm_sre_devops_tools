# GCP operational utilities

[`asset_change_timeline.py`](asset_change_timeline.py) читает историю явно
указанных ресурсов через штатную команду `gcloud asset get-history`. Python SDK
не требуется; используется активная `gcloud`-сессия.

## Подготовка и запуск

```bash
cd 1_linux/3_scripts_bash_python/python/cloud/gcp
gcloud auth login
gcloud config set project example-project

./asset_change_timeline.py --project example-project \
  --asset //compute.googleapis.com/projects/example-project/zones/europe-west1-b/instances/api

./asset_change_timeline.py --organization 123456789 \
  --asset //cloudresourcemanager.googleapis.com/projects/example-project \
  --content-type iam-policy --json
```

Scope (`--project` или `--organization`) обязателен, как и хотя бы один полный
Cloud Asset name через `--asset`. Команда read-only; `--details` добавляет
provider payload, который может быть большим и содержать чувствительные
metadata, поэтому по умолчанию он исключён.

Коды возврата: `0` — история найдена, `3` — истории нет, `2` — локальная ошибка
или ошибка `gcloud`. Start time ограничен последними 35 днями; скрипт проверяет
это через `--hours`. Нужны включённый Cloud Asset API и права чтения истории в
выбранном scope. Точный формат asset names и ограничения описаны в
[`gcloud asset get-history`](https://cloud.google.com/sdk/gcloud/reference/asset/get-history).

Остальные кандидаты — orphan/public exposure/IAM audits и inventory — пока
только roadmap в [`../../../SCRIPT_BACKLOG.md`](../../../SCRIPT_BACKLOG.md).
