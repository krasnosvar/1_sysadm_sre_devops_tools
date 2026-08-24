# DevOps / SRE теория — что изучать

> Полная база знаний по DevOps/SRE/MLOps с теорией и практикой:
> **[5_devops_sre_knowledgebase/](../../5_devops_sre_knowledgebase/)**

## Основы

- [What Is DevOps?](https://www.atlassian.com/devops) — Atlassian
- [School of SRE](https://linkedin.github.io/school-of-sre/) — LinkedIn's бесплатный SRE курс
- [What is the Agile methodology?](https://www.atlassian.com/agile)
- [CI vs CD vs Continuous Deployment](https://www.atlassian.com/continuous-delivery/principles/continuous-integration-vs-delivery-vs-deployment)
- [roadmap.sh/devops](https://roadmap.sh/devops) — интерактивный roadmap

## Книги

- **Site Reliability Engineering** (Google) — [бесплатно](https://sre.google/sre-book/table-of-contents/). Главы про SLO, error budget, toil.
- **The Phoenix Project** — роман о DevOps трансформации, легко читается.
- **Accelerate** (Forsgren) — исследование DORA метрик и высокоэффективных команд.
- **Release It!** (Nygard) — паттерны надёжности: circuit breaker, timeout, bulkhead.
- **Team Topologies** — как организовать команды для быстрой поставки.

## DORA метрики

Четыре ключевых метрики из книги Accelerate:

| Метрика | Elite |
| ------- | ----- |
| Deployment Frequency | Несколько раз в день |
| Lead Time for Changes | < 1 часа |
| Change Failure Rate | < 5% |
| MTTR | < 1 часа |

## Практика

- [KodeKloud](https://kodekloud.com/) — DevOps, k8s, Terraform, GitOps с лабами
- [Killercoda](https://killercoda.com/) — бесплатные интерактивные лабы в браузере
- [CNCF Landscape](https://landscape.cncf.io/) — карта cloud-native инструментов

## Шпаргалки и примеры

- CI/CD (GitLab, Ansible) → `../1_linux/2_services/2_config_management_ci-cd/`
- Monitoring (Prometheus, Loki, Tracing) → `../1_linux/2_services/4_monitoring_and_log_tools/`
