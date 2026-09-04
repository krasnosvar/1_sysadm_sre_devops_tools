# SysAdmin / SRE / DevOps tools

Практический полевой справочник: команды для диагностики, рабочие конфигурации,
утилиты автоматизации и скрипты восстановления workstation. Репозиторий отвечает
на вопрос «как выполнить операционную задачу» и не дублирует учебные базы серии.

## Быстрая навигация

| Раздел | Назначение |
| --- | --- |
| [`1_linux/`](1_linux/) | Linux command reference, сервисные примеры и основной набор автоматизации |
| [`1_linux/fedora/`](1_linux/fedora/) | Основной/reference bootstrap для Fedora Workstation |
| [`1_linux/ubuntu/`](1_linux/ubuntu/) | Bootstrap Ubuntu и явно отмеченный архив старых версий |
| [`1_linux/3_scripts_bash_python/`](1_linux/3_scripts_bash_python/) | Готовые Bash/Python/Go утилиты для операционных задач |
| [`2_win/`](2_win/) | Windows/PowerShell bootstrap и команды |
| [`3_macos/`](3_macos/) | macOS и Fedora Asahi bootstrap |
| [`PLATFORM_PARITY.md`](PLATFORM_PARITY.md) | Функциональное покрытие Fedora, macOS, Windows и WSL |
| [`what_to_learn/`](what_to_learn/) | Сохранённые legacy notes и указатель на канонические учебные репозитории |

`.sh` в command-reference каталогах — читаемые фрагменты команд с shell
подсветкой. Они не обязаны быть целыми исполняемыми программами. Запускаемыми
считаются файлы, которые прямо указаны как utilities или bootstrap scripts.

## Как выбрать язык автоматизации

| Задача | Инструмент по умолчанию | Почему |
| --- | --- | --- |
| Последовательно вызвать несколько системных команд, склеить Unix tools, оформить runbook | Bash | Минимум зависимостей и прямой доступ к CLI |
| Надёжно разобрать или изменить JSON/YAML/CSV, вызвать API, обработать данные | Python | Сильные библиотеки и ясная модель данных |
| Проверять сеть параллельно, написать долгоживущий agent/exporter или переносимый static binary | Go | Goroutines, `context`, строгие типы и простой deploy |
| Декларативно описать конфигурацию или ресурс | YAML/HCL/Ansible | Данные и desired state не маскируются процедурным кодом |

Если задача решается коротким вызовом `jq`, `yq` или `kubectl`, новый скрипт не
нужен. Python или Go выбираются только когда они заметно повышают надёжность,
проверяемость или производительность.

## Связанные репозитории

| Репозиторий | Владеет содержимым |
| --- | --- |
| [`2_lin_win_mac_apps_bkp`](https://github.com/krasnosvar/2_lin_win_mac_apps_bkp) | Офлайн-копии установщиков, ISO и package manifests |
| [`3_go_my_knowledgebase`](https://github.com/krasnosvar/3_go_my_knowledgebase) | Изучение Go, concurrency, backend и system design |
| [`4_python_my_knowledgebase`](https://github.com/krasnosvar/4_python_my_knowledgebase) | Изучение Python, библиотек, backend и system design |
| [`5_devops_sre_knowledgebase`](https://github.com/krasnosvar/5_devops_sre_knowledgebase) | Теория, labs и roadmap по DevOps/SRE/MLOps |
| [`aws-opencost-cloud-costs-exporter`](https://github.com/krasnosvar/aws-opencost-cloud-costs-exporter) | Production-like Go/Python exporter и AWS/OpenCost интеграция |

Новая теория, упражнения и учебные mini-projects должны изменяться в
соответствующей knowledgebase. Старые notes в `what_to_learn/` сохраняются до
проверенной миграции; наличие копии здесь не делает её каноническим источником.

## Безопасность

- не коммить secrets, kubeconfig, SSH/VPN keys и рабочие inventory;
- перед реальным запуском проверяй placeholders, environment и destructive flags;
- старые примеры могут быть сохранены как historical/reference и требуют ревью;
- bootstrap сначала запускай с `--check` или `--dry-run`, если режим поддержан.

## Проверки

GitHub Actions проверяет maintained Bash/Zsh/PowerShell scripts, компиляцию и
Ruff для Python, а также `gofmt`, `go vet` и `go test` для Go utility. Проверка
не исполняет workstation installers. Command-reference `.sh` исключены из
`bash -n` намеренно: часть из них содержит вывод команд и конфиги для копирования.
