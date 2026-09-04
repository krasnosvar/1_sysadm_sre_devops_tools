# Безопасная диагностика и однократный restart systemd-сервиса

[`service_recovery_guard.sh`](service_recovery_guard.sh) нужен для типового
инцидента «unit или его health endpoint не отвечает». По умолчанию он ничего не
меняет: проверяет состояние, а при ошибке сохраняет evidence. Restart разрешён
только явным `--apply` и выполняется не более одного раза за запуск.

## Что попадает в evidence

- `systemctl status` и ключевые свойства unit;
- journal выбранного unit за заданный период;
- listening sockets;
- состояние, limits, cgroup и process tree основного процесса;
- вывод отдельной health-команды, если она передана.

Каталог создаётся с правами текущего пользователя и `umask 077`. Health-команда
и её вывод также сохраняются, поэтому не передавайте секреты в аргументах и
выбирайте защищённый `--output-parent`.

## Использование

```bash
cd 1_linux/3_scripts_bash_python/bash

# Только проверка systemd; при проблеме будет создан evidence-каталог
./service_recovery_guard.sh nginx

# Проверка unit и приложения
./service_recovery_guard.sh nginx -- \
  curl --fail --silent --show-error --max-time 5 http://127.0.0.1/health

# Один restart после сбора evidence, затем повторная проверка
sudo ./service_recovery_guard.sh --apply --grace 5 \
  --output-parent /var/tmp nginx -- \
  curl --fail --silent --show-error --max-time 5 http://127.0.0.1/health
```

`--journal-since '2 hours ago'` расширяет период журнала. Пользователю нужны
права на чтение journal и состояния unit; для restart обычно нужен `sudo`.

## Результат и ограничения

| Код | Значение |
| --- | --- |
| `0` | сервис был здоров либо восстановился после одного restart |
| `1` | сервис остался нездоров; путь к evidence выведен в stderr |
| `2` | неверные аргументы или отсутствует обязательная команда |

Скрипт не анализирует зависимости приложения, не исправляет конфигурацию и не
делает restart loop. Между отдельными запусками ограничение должен обеспечивать
systemd (`StartLimit*`), alert manager или вызывающий automation. Перед
`--apply` сначала просмотрите evidence из read-only запуска.
