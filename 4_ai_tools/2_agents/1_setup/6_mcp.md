# MCP: внешние инструменты и данные

Источники: https://code.claude.com/docs/en/mcp,
https://learn.chatgpt.com/docs/extend/mcp?surface=cli,
https://modelcontextprotocol.io

## Что это

Открытый протокол подключения инструментов и данных. Сервер даёт
агенту новые действия: Kubernetes, база данных, трекер задач.
Каждый сервер это код с вашими правами и канал для чужого контента.

## Claude Code: команды

```text
claude mcp add --transport http <name> <url>
claude mcp add --env KEY=VALUE --transport stdio <name> -- <command>
claude mcp add-json <name> '<json>'
claude mcp list
claude mcp remove <name>
```

`/mcp` в сессии показывает состояние. SSE помечен устаревшим; начиная
с v2.1.265 клиент сначала пробует HTTP.

## Области

| Scope | Файл | Кому видно |
| --- | --- | --- |
| local (по умолчанию) | `~/.claude.json` | Вам, в этом проекте |
| project | `.mcp.json` | Команде, через git |
| user | `~/.claude.json` | Вам, во всех проектах |

Приоритет: local, project, user, plugin, connectors claude.ai;
организационные managed-серверы выше всех. Записи целиком не
сливаются. В `.mcp.json` работают `${VAR}` и `${VAR:-default}`;
секреты храните в переменных окружения.

```json
{
  "mcpServers": {
    "docs": {
      "type": "http",
      "url": "https://example.com/mcp",
      "headers": {"Authorization": "Bearer ${DOCS_TOKEN}"}
    }
  }
}
```

## Расход токенов

Tool search включён по умолчанию: определения инструментов
откладываются и подгружаются по требованию. Переменная
`ENABLE_TOOL_SEARCH`: не задана или `true` (всё отложено), `auto`
или `auto:N` (порог N% контекста, по умолчанию 10), `false` (всё
сразу). На старых моделях инструменты грузятся заранее. Число токенов
на схемы конкретного сервера не проверено.

Результат инструмента остаётся в истории и пересылается на каждом
ходу. Лимит вывода: `MAX_MCP_OUTPUT_TOKENS`; результаты длиннее 50000
символов сохраняются в файл. Тяжёлую диагностику поручайте
[субагенту](3_subagents_roles.md) или используйте фильтры CLI
(например, `kubectl ... --field-selector`).

Таймауты: `MCP_TIMEOUT` (запуск), `MCP_TOOL_TIMEOUT`, поле `timeout`
в записи сервера.

## Codex

`codex mcp add <name> --env K=V -- <cmd>`, конфиг
`[mcp_servers.<name>]` в `~/.codex/config.toml` или `.codex/config.toml`
доверенного проекта. Опции: `enabled_tools`, `disabled_tools`,
`default_tools_approval_mode`, `startup_timeout_sec`,
`tool_timeout_sec`, `required`. Ленивая загрузка инструментов в
Codex: не проверено.

## Безопасность

- Серверы, читающие внешний контент, подвержены prompt injection.
- `.mcp.json` требует одобрения в интерактивной сессии; сброс:
  `claude mcp reset-project-choices`.
- Не передавайте серверу больше прав, чем нужно: отдельный
  read-only токен.
- Организация: `managed-mcp.json`, `--strict-mcp-config`,
  `disabledMcpjsonServers`.
- Не подключайте сервер лишь ради наличия: определите задачу,
  права, источник, проверку и способ отключения.

## Как проверить

`claude mcp list`, затем вызов одного безопасного инструмента.
Отключение: `claude mcp remove <name>` и новая сессия.
