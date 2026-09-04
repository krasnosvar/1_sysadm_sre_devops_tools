# Cloud operations

Provider-specific CLI для инвентаризации, аудита и ограниченных операционных
изменений. Это каталог утилит, а не учебный материал по облакам.

## Провайдеры

- [`aws/`](aws/) — Amazon Web Services. Реализованы S3 retention cleaner и
  управление питанием EC2 по обязательному tag filter, а также CloudTrail
  timeline «кто изменил ресурс».
- [`gcp/`](gcp/) — Google Cloud Platform. Реализована временная шкала Cloud
  Asset Inventory для явно указанных ресурсов.
- [`azure/`](azure/) — Microsoft Azure. Реализована временная шкала Resource
  Graph `resourcechanges` для выбранных subscriptions.
- [`multi_cloud/`](multi_cloud/) — проверки с общей моделью результата для
  нескольких провайдеров. Пока roadmap.

Полный приоритетный список находится в
[`../../SCRIPT_BACKLOG.md`](../../SCRIPT_BACKLOG.md). Наличие пункта в backlog
не означает, что соответствующая команда уже реализована.

## Общие правила

- Credentials получает официальный SDK или штатный provider CLI из стандартной
  credential chain/session.
- Секреты не принимаются через аргументы командной строки и не пишутся в output.
- Инвентаризация и аудит по умолчанию read-only.
- Любая мутация требует `--apply`, узкого scope и предварительного preview.
- Все сетевые обращения имеют timeout, а пагинация и throttling обрабатываются
  явно.
- Основной machine-readable output — JSON или JSON Lines; диагностика идёт в
  stderr, а результат — в stdout.
