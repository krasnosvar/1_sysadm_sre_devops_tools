# Gemini CLI

Документация: https://geminicli.com/docs/. Репозиторий:
https://github.com/google-gemini/gemini-cli. Последний релиз v0.69.0
(2026-11-19).

На страницах документации указано: Gemini CLI заменён Antigravity CLI
(2026-06-18) для бесплатного уровня и Google One, а для Gemini 4 Argon он
не оптимизирован. Анонс по ссылке из документации не открывался. Для
Antigravity см. [руководство](../antigravity/README.md). Описанное ниже
относится к Gemini CLI.

## Инструкции

`~/.gemini/GEMINI.md` и `GEMINI.md` в проекте и его родителях,
загрузка по требованию, импорт `@file.md`. Имя файла меняет настройка
`context.fileName`, например на `AGENTS.md`. Команды `/memory show` и
`/memory reload`. Общие принципы: [инструкции](../../1_setup/1_instructions.md).

## Режимы подтверждений и Policy Engine

Режимы: `default`, `auto_edit`, `plan` (только чтение), `yolo`. Флаг
`--approval-mode default|auto_edit|yolo|plan`. Флаги `--yolo` и
`--allowed-tools` устарели в пользу Policy Engine. Настройки:
`general.defaultApprovalMode`, `security.disableYoloMode`.

Политики в TOML-файлах:

- пользователь: `~/.gemini/policies/*.toml`;
- проект: `.gemini/policies/*.toml` (по документации этот уровень сейчас
  отключён);
- администратор: `/etc/gemini-cli/policies` (Linux),
  `/Library/Application Support/GeminiCli/policies` (macOS),
  `C:\ProgramData\gemini-cli\policies` (Windows).

Поля правила `[[rule]]`: `toolName`, `subagent`, `mcpName`,
`toolAnnotations`, `argsPattern`, `commandPrefix`, `commandRegex`,
`decision` (`allow`, `deny`, `ask_user`; обязательно), `priority`
(0-999; обязательно), `denyMessage`, `modes`, `interactive`. В
неинтерактивном режиме `ask_user` работает как `deny`. Побеждает
правило с высшим приоритетом.

```toml
[[rule]]
toolName = "run_shell_command"
commandPrefix = "rm -rf"
decision = "deny"
priority = 100
```

Источник: https://geminicli.com/docs/reference/policy-engine/

## Sandbox

Варианты: macOS Seatbelt, Docker или Podman (образ
`ghcr.io/google/gemini-cli:latest`), Windows native, gVisor (`runsc`,
Linux), LXC (Linux, экспериментально). Включение: `gemini -s` или
переменная `GEMINI_SANDBOX=true|docker|podman|sandbox-exec|runsc|lxc`;
приоритет: флаг, затем переменная, затем настройки. Профили Seatbelt:
`permissive-open` (по умолчанию), `restrictive-open`, `strict-open` и
варианты `-proxied`. Дополнительно: `GEMINI_SANDBOX_IMAGE`,
`SANDBOX_MOUNTS`, `SANDBOX_FLAGS`, `BUILD_SANDBOX=1`
(`.gemini/sandbox.Dockerfile`).

```json
{"tools": {"sandbox": {"command": "docker", "image": "my-image:latest"}}}
```

Источник: https://geminicli.com/docs/cli/sandbox/

## Субагенты

Включены по умолчанию (`experimental.enableAgents=false` отключает).
Файлы `.gemini/agents/*.md` (проект) и `~/.gemini/agents/*.md`
(пользователь), а также `agents/` в расширениях. Markdown с
frontmatter, тело это системный промпт.

Поля: `name`, `description` (обязательны), `kind` (`local`, `remote`),
`tools` (в том числе `*`, `mcp_*`), `mcpServers`, `model`,
`temperature`, `max_turns` (по умолчанию 30), `timeout_mins` (10).
Вызов автоматически или `@имя задача`. Встроенные: `codebase_investigator`,
`cli_help`, `generalist`, `browser_agent` (выключен). Флаг `--model`
модель субагентов не меняет.

```text
---
name: security-auditor
description: Finds security vulnerabilities.
tools: [read_file, grep_search]
max_turns: 10
---
Проверь код на уязвимости, укажи файл и строку.
```

Источник: https://geminicli.com/docs/core/subagents/

## MCP

`mcpServers` в `settings.json`: транспорт один из `command` (stdio),
`url` (SSE), `httpUrl` (streamable HTTP). Поля: `args`, `env`
(`$VAR`, `${VAR}`), `cwd`, `headers`, `timeout` (по умолчанию 600000 мс),
`trust` (по умолчанию false), `includeTools`, `excludeTools` (приоритетнее),
`oauth`. Глобально `mcp.allowed`, `mcp.excluded`.

```json
{"mcpServers": {"docs": {"httpUrl": "https://api.example.com/mcp/",
  "headers": {"Authorization": "Bearer $DOCS_TOKEN"}}}}
```

Команды: `gemini mcp add [-s user|project] [-t stdio|sse|http] [-e K=V]
<name> <commandOrUrl>`, `list`, `remove`, `enable`, `disable`; в сессии
`/mcp enable|disable`, `/mcp auth`. Инструменты называются
`mcp_{server}_{tool}`, имя до 63 символов, в имени сервера не
используйте `_`.

Безопасность: `trust: true` отключает все подтверждения. Из
унаследованного окружения вычищаются переменные с `TOKEN`, `SECRET`,
`PASSWORD`, `KEY`, `AUTH`, `CREDENTIAL`. Stdio-сервер в недоверенной
папке не подключается, лечится `gemini trust`. OAuth: токены в
`~/.gemini/mcp-oauth-tokens.json`. Общие принципы:
[MCP](../../1_setup/6_mcp.md).

Источник: https://geminicli.com/docs/tools/mcp-server/

## Настройки

Уровни (приоритет от низкого к высокому): значения по умолчанию,
системные умолчания (`/etc/gemini-cli/system-defaults.json`), пользователь
(`~/.gemini/settings.json`), проект (`.gemini/settings.json`), системные
переопределения (`/etc/gemini-cli/settings.json`), переменные окружения
(включая `.env`), аргументы командной строки. Подстановка `$VAR`,
`${VAR}`, `${VAR:-default}`. Файл `.env` ищется от текущей папки вверх до
`.git` или домашней, затем `~/.env`.

Ключи: `general.defaultApprovalMode`, `model.name`, `tools.sandbox`,
`security.folderTrust.enabled`, `security.auth.selectedType`,
`context.fileName`. Переменные: `GEMINI_API_KEY`, `GEMINI_MODEL`,
`GOOGLE_CLOUD_PROJECT`, `GEMINI_CLI_HOME`.

Источник: https://geminicli.com/docs/reference/configuration/ (страница
прочитана не до конца)

## Расширения и свои команды

Расширение: каталог `~/.gemini/extensions/<name>/` с файлом
`gemini-extension.json` (`name`, `version`, `description`, `mcpServers`,
`contextFileName`, `excludeTools`, `settings`). Внутри могут быть
`commands/*.toml`, `hooks/hooks.json`, `skills/<n>/SKILL.md`,
`agents/*.md`, `policies/*.toml`. Команды: `gemini extensions install
<src>`, `uninstall`, `enable`, `disable`, `update`, `new`, `link`.
Правила `allow` и `yolo` в политиках расширений игнорируются.
Источник: https://geminicli.com/docs/extensions/reference/

Свои команды: `~/.gemini/commands/` и `.gemini/commands/` в проекте
(проект приоритетнее); `git/commit.toml` вызывается как `/git:commit`.
Поля `prompt` (обязательно) и `description`; плейсхолдеры `{{args}}`,
`!{shell}` (с подтверждением), `@{file}`.

```toml
description = "Чистый рефакторинг"
prompt = "Преобразуй в чистую функцию: {{args}}"
```

Источник: https://geminicli.com/docs/cli/custom-commands/

## Hooks и skills

Hooks: ключ `hooks` в `settings.json`, только `type: "command"`, события
`BeforeTool`, `AfterTool`, `BeforeModel`, `AfterModel`, `BeforeAgent`,
`AfterAgent`, `SessionStart`, `SessionEnd`; код 2 блокирует
([hooks](../../1_setup/5_hooks.md)). Skills: `~/.gemini/skills/`,
`.gemini/skills/`, `.agents/skills/`; модель вызывает `activate_skill`
с подтверждением ([skills](../../1_setup/4_skills.md)).

## Вход, лимиты, модели

Вход: учётная запись Google (для Workspace нужен проект Cloud), ключ
`GEMINI_API_KEY` (AI Studio), Vertex AI (`GOOGLE_CLOUD_PROJECT`,
`GOOGLE_CLOUD_LOCATION`, ADC или сервисный ключ).

Лимиты по документации (страница может быть устаревшей из-за перехода на
Antigravity): аккаунт Google 1000 запросов в день; ключ API без оплаты
250 в день (только Flash); AI Pro 1500; AI Ultra 2000; Code Assist
Standard 1500, Enterprise 2000. Модели: `/model` (Auto Gemini 3 или
2.5, Manual), флаг `--model` (`auto`, `pro`, `flash`, `flash-lite` или имя),
`GEMINI_MODEL`. Сторонние (не Gemini) модели в документации не найдены.

Источники: https://geminicli.com/docs/get-started/authentication/,
https://geminicli.com/docs/resources/quota-and-pricing/,
https://geminicli.com/docs/cli/model/
