# Desktop-приложения

Настройки Desktop отличаются от CLI: другие файлы, графические коннекторы, часть
режимов недоступна. Изменение локального JSON CLI не настраивает Desktop
автоматически.

## Claude Desktop: MCP

Источник: https://modelcontextprotocol.io/docs/develop/connect-local-servers

Файл `claude_desktop_config.json`, ключ `mcpServers`
(`command`, `args`, `env`):

- macOS: `~/Library/Application Support/Claude/`
- Windows: `%APPDATA%\Claude\`
- Linux: `~/.config/Claude/`

Открытие: Settings, Developer, Edit Config. После правки нужен полный
перезапуск приложения. Пути в `command` и `args` абсолютные.

```json
{
  "mcpServers": {
    "example": {
      "command": "/usr/local/bin/example-mcp",
      "args": ["--read-only"],
      "env": {"EXAMPLE_TOKEN": "<токен>"}
    }
  }
}
```

Логи: `mcp.log` и `mcp-server-NAME.log` (macOS `~/Library/Logs/Claude`,
Linux `~/.config/Claude/logs`). Сервер работает с правами
пользователя, действия требуют одобрения.

## Claude Desktop: Extensions (.mcpb)

Источник:
https://support.claude.com/en/articles/10949351-getting-started-with-local-mcp-servers-on-claude-desktop

Пакеты локальных MCP-серверов в один клик: Settings, Desktop app,
Extensions, Browse. Свой пакет: `manifest.json` и `mcpb pack`, установка
через Advanced settings, Extension Developer. Поля с
`"sensitive": true` шифруются хранилищем ОС. Политика предприятия
на машине перекрывает блок-листы приложения.

Проекты (Projects) Claude Desktop: не проверено.

## Claude Code в Desktop

Источник: https://code.claude.com/docs/en/desktop

- Из `~/.claude/settings.json` читается частично:
  `permissions.defaultMode`, `env`, `disableRemoteControl`.
- Connectors (MCP с графической настройкой) настраиваются в
  Customize, Connectors и синхронизируются через аккаунт claude.ai.
- Локальные сессии берут personal skills из `~/.claude/skills/`.
- Среды: Local, Cloud, SSH, WSL. В Cloud плагины, установленные в
  Desktop, недоступны.
- Режим `dontAsk` есть только в CLI.
- Выбранный в локальной сессии режим запоминается по папке и
  перекрывает `defaultMode` проекта.
- Worktrees лежат в `<проект>/.claude/worktrees/` и по умолчанию
  выключены.

## Codex App

Источник: https://learn.chatgpt.com/docs/extend/mcp?surface=app

MCP: Settings, MCP servers, Add server. Приложение, CLI и расширение
IDE делят один `~/.codex/config.toml` (и `.codex/config.toml`
доверенного проекта). Worktrees и локальные окружения Codex App: не
проверено. Адрес developers.openai.com/codex перенаправляется на
learn.chatgpt.com/docs (домен подтверждён заголовком перенаправления,
независимо не проверен).

## Как проверить

После правки конфига перезапустите приложение, откройте список
инструментов, вызовите один безопасный. Откат: верните сохранённый
файл и перезапустите.

Общая настройка механизмов: [1_setup](../../1_setup/README.md).
