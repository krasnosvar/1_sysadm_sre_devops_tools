# Multi-cloud utilities

Здесь будут только проверки, для которых действительно полезен единый контракт
AWS, GCP и Azure: обязательные tags/labels, TTL временных ресурсов, coverage
backup, истечение identity credentials и нормализованный public exposure report.

Provider-specific детали не скрываются за искусственной общей абстракцией:
каждый результат должен содержать provider, account/project/subscription,
region, resource type, resource ID и причину finding.

Сейчас каталог является roadmap. Канонический список и критерии готовности — в
[`../../../SCRIPT_BACKLOG.md`](../../../SCRIPT_BACKLOG.md).
