# Google Antigravity CLI (agy)

CLI называется `agy`. Команды `gemini` и `antigravity` его не заменяют.
CLI, IDE и Python SDK настраиваются по-разному: настройки SDK не
переносятся в CLI. Документация: https://antigravity.google/docs/

## Связь с Gemini CLI

Страница https://geminicli.com/plans/ сообщает: для бесплатного
уровня и пользователей Google One Gemini CLI заменён Antigravity CLI
2026-06-18. Раздел документации Antigravity о миграции даты не называет
и не утверждает, что Gemini CLI закрыт. Описание Gemini CLI:
[gemini-cli](../gemini-cli/README.md).

Миграция по документации: `agy plugin import gemini`, перенос
`.gemini/skills` в `.agents/skills`, перенос MCP из `settings.json` в
`mcp_config.json`, замена `url` или `httpUrl` на `serverUrl`.

## Установка и запуск

Скрипт установки из документации (прочитайте его перед запуском):

```text
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

Бинарник `~/.local/bin/agy`, проверка `agy --version`. Если `agy` не
запускается, проверьте `PATH`.

Подкоманды: `agy plugin install|list|enable|disable|uninstall|validate|import`,
`agy models`, `agy agents`. Флаги: `-p` (неинтерактивно), `-i`, `-c`,
`--conversation`, `--mode`, `--model`, `--effort`, `--agent`, `--add-dir`,
`--output-format`, `--json-schema`, `--sandbox`, `--print-timeout`,
`--dangerously-skip-permissions`. Последний флаг отключает подтверждения:
используйте только в изолированной среде. Команда `agy -p` подходит для
скриптов и CI.

Слеш-команды: `/config` и `/settings`, `/agents`, `/resume`, `/context`,
`/usage` (квоты моделей), `/credits` (кредиты), `/effort`, `/mcp`,
`/hooks`, `/skills reload`, `/plugin`, `/teamwork`, `/swarm`.

## Инструкции

Личные: `~/.gemini/GEMINI.md`, также `~/.gemini/AGENTS.md` и
`~/.gemini/config/{AGENTS,GEMINI}.md`. Проектные: `AGENTS.md`,
`GEMINI.md`, `.agents/rules/*.md`. CLI проходит от рабочего каталога до
корня репозитория (`.git`); подкаталоги ниже рабочего не читаются
автоматически. Модульным правилам нужен frontmatter с `trigger`, для
`AGENTS.md` и `GEMINI.md` он не нужен (всегда включены). Правила
накапливаются, порядок приоритета при конфликте не определён.
Ограничения: 24000 байт на файл и 20000 токенов суммарно; неверный
`trigger` молча отбрасывается. Общие принципы:
[инструкции](../../1_setup/1_instructions.md).

Источники: https://antigravity.google/docs/rules/,
https://antigravity.google/docs/customization-discovery/

## Настройки, модели, effort

Файл `~/.gemini/antigravity-cli/settings.json`; флаги запуска
переопределяют его. `.gemini/settings.json` другого клиента этим файлом
не является. Уровень рассуждения: флаг `--effort` (от `low` до `max`;
`xhigh` и `max` только у части моделей, Orchestrator не поддерживает) или
`/effort`. Для субагентов `model`: `inherit`, `flash` или `pro`.

Модели по странице документации: на бесплатном тарифе и Plus
доступны Gemini 3.8 Flash, Claude 4.6 и GPT-OSS-120B (последние два
помечены к удалению 2026-11-18); модель по умолчанию Gemini 4 Neon
платная; Sonnet 5.5 и Opus 5.5 для Pro (не пробный) и Ultra. Список
меняется, проверяйте `agy models`.

Тарифы: на странице плана нет цен и чисел. Free: заметная квота с
недельным обновлением; Pro: обновление каждые 5 часов плюс недельный
лимит; Ultra выше; Workspace повышенных лимитов не даёт; кредиты только
Pro и Ultra. Источники: https://antigravity.google/docs/cli/using/,
https://antigravity.google/docs/models/,
https://antigravity.google/docs/plans/

## Права и sandbox

В `settings.json` ключи `permissions.allow`, `permissions.deny`,
`permissions.ask`; приоритет Deny, затем Ask, затем Allow. Режимы:
`auto`, `accept-edits`, `default` (режим `auto` недоступен для business и
enterprise). Параметр `toolPermission`: `strict`, `always-proceed`,
`proceed-in-sandbox`, `request-review`.

Sandbox: флаг `--sandbox` или `enableTerminalSandbox` (по умолчанию
выключен); нужен Windows 11 24H2 или новее, на Linux нужны user
namespaces; `~/.ssh` и `.env` блокируются. Источники:
https://antigravity.google/docs/permissions/,
https://antigravity.google/docs/sandbox/

## Субагенты

Файлы: `.agents/agents/<name>.md` (проект), `~/.gemini/config/agents/`
(личные). Поля: `name`, `description`, `tools`, `mainAgent`, `subagent`,
`model`, `commandExecutionPolicy` (`off`, `auto`, `eager`, `sandbox`; по
умолчанию `sandbox`), `mcpServers`, `skills`, `plugins`. Глубина
вложенности до 10; доступен инструмент `define_subagent`. Неверное имя
инструмента может подвесить субагента. Пример роли для чтения:
[bounded-researcher.md](examples/bounded-researcher.md) (разрешает
`view_file` и `grep_search`).

Проверка: `/agents` показывает роль, затем один безопасный запрос
(найти вызывающий код функции без правок) и проверка ответа по коду.
Приоритет одноимённых агентов и skills: личные в репозитории, затем
проект, затем `~/.gemini/config`, затем встроенные.

`/teamwork` доступен только на платных планах; `/swarm` только Pro и
Ultra, находится в Preview и расходует квоту. Источник:
https://antigravity.google/docs/subagents/

## MCP, hooks, skills, плагины

- MCP: `~/.gemini/config/mcp_config.json` и `.agents/mcp_config.json`, корень
  `mcpServers`, адрес в поле `serverUrl` (`httpUrl` не поддерживается);
  управление `/mcp`. https://antigravity.google/docs/mcp/ ([общие
  принципы](../../1_setup/6_mcp.md))
- Hooks: `.agents/hooks.json`, `~/.gemini/config/hooks.json`; hooks в
  `settings.json` не загружаются. События `SessionStart`, `PreToolUse`,
  `PostToolUse`, `PreInvocation`, `PostInvocation`, `Stop`.
  https://antigravity.google/docs/hooks/ ([hooks](../../1_setup/5_hooks.md))
- Skills: `skills/<name>/SKILL.md`; CLI также читает `~/.gemini/skills` и
  `~/.gemini/antigravity-cli/skills` с высшим приоритетом.
  https://antigravity.google/docs/skills/ ([skills](../../1_setup/4_skills.md))
- Плагины: `plugin.json`, команда `agy plugin`.
  https://antigravity.google/docs/plugins/

Python SDK отдельный (Python 3.10+, `pip install google-antigravity`) и
не доказывает поддержку тех же настроек в CLI:
https://antigravity.google/docs/sdk/overview/
