# Где лежат учебные материалы

Каталог сохраняет прежние notes, roadmap и упражнения как legacy snapshot.
Канонические и развиваемые версии находятся в отдельных репозиториях; новый
учебный материал сюда не дублируется. Старые файлы удаляются только после
проверки, что их содержание перенесено в owning knowledgebase.

| Что изучать | Канонический репозиторий |
| --- | --- |
| Linux, containers, Kubernetes, IaC, CI/CD, observability, SRE, security, MLOps | [`5_devops_sre_knowledgebase`](https://github.com/krasnosvar/5_devops_sre_knowledgebase) |
| Go, стандартная библиотека, concurrency, backend, system design | [`3_go_my_knowledgebase`](https://github.com/krasnosvar/3_go_my_knowledgebase) |
| Python, tooling, asyncio, backend, data/messaging, system design | [`4_python_my_knowledgebase`](https://github.com/krasnosvar/4_python_my_knowledgebase) |

Практические команды остаются в [`../1_linux/`](../1_linux/), а готовые
операционные утилиты — в
[`../1_linux/3_scripts_bash_python/`](../1_linux/3_scripts_bash_python/).

Правило изменения: теория и лабораторные задания исправляются в owning
knowledgebase. В этой репе обновляется ссылка либо относящаяся к реальной
эксплуатации команда/утилита; legacy snapshot не считается источником истины.
