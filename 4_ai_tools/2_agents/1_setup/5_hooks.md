# Hooks

Источники: https://code.claude.com/docs/en/hooks,
https://code.claude.com/docs/en/hooks-guide,
https://learn.chatgpt.com/docs/hooks,
https://geminicli.com/docs/hooks/

## Что это

Команда, которую клиент запускает по событию, вне рассуждения модели.
Подходит для жёстких запретов, автоформатирования, уведомлений. Это
код с вашими правами: доверяйте только проверенному обработчику.

## События

Claude Code (около 33): сессия (`SessionStart`, `SessionEnd`), ход
(`UserPromptSubmit`, `Stop`), инструменты (`PreToolUse`,
`PermissionRequest`, `PostToolUse`, `PostToolUseFailure`), субагенты
(`SubagentStart`, `SubagentStop`), компакция (`PreCompact`,
`PostCompact`), окружение (`InstructionsLoaded`, `ConfigChange`,
`FileChanged`, `WorktreeCreate`) и другие. Полный список в документации.

Codex: `PreToolUse`, `PermissionRequest`, `PostToolUse`, `Stop`,
`UserPromptSubmit`, `SessionStart`, события компакции и субагентов.
Gemini CLI: `BeforeTool`, `AfterTool`, `BeforeModel`, `AfterModel`,
`BeforeAgent`, `AfterAgent`, `SessionStart`, `SessionEnd` и другие.

## Формат (Claude Code)

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {"type": "command", "command": ".claude/hooks/guard.sh"}
        ]
      }
    ]
  }
}
```

Типы: `command`, `http`, `mcp_tool`, `prompt`, `agent` (экспериментальный).
Matcher: имена через `|` сравниваются точно, любой другой символ делает
его регулярным выражением, регистр важен. Таймаут по умолчанию 600 с
для command. Где лежат: настройки пользователя и проекта, managed,
`hooks/hooks.json` плагина, frontmatter skill и субагента.

Codex: `hooks.json` или секция `[hooks]` в `config.toml`; проектный файл
работает только в доверенном проекте; не-managed хуки нужно одобрить
в `/hooks`. Gemini CLI: ключ `hooks` в `settings.json`, только
`type: "command"`, таймаут в миллисекундах.

## Коды выхода

- 0: успех, stdout разбирается как JSON, если это один объект.
- 2: блокировка на событиях, которые умеют блокировать, причина из
  stderr.
- Другие коды: действие продолжается (в Claude Code исключение
  `onFailure: "block"`).

Для политики используйте код 2, а не 1. Решение PreToolUse в JSON:
`hookSpecificOutput.permissionDecision` (`allow`, `deny`, `ask`,
`defer`); поле на верхнем уровне игнорируется.

## Пример: блок опасной команды

```bash
#!/usr/bin/env bash
# .claude/hooks/guard.sh: читает JSON события со stdin
cmd=$(jq -r '.tool_input.command')
if echo "$cmd" | grep -qiE 'drop table|rm -rf /'; then
  echo "Заблокировано политикой проекта" >&2
  exit 2
fi
exit 0
```

Сделайте скрипт исполняемым. Это защита от случайной ошибки, а не
граница безопасности.

## Пример: форматирование после правки

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {"type": "command",
           "command": "f=$(jq -r '.tool_input.file_path') && npx prettier --write --ignore-unknown \"$f\""}
        ]
      }
    ]
  }
}
```

## Риски

- Права пользователя: чужой хук может сделать что угодно.
- Проектные хуки работают только после доверия папке.
- Deny из хука действует даже в `bypassPermissions`; allow из хука не
  обходит правила deny и ask.
- Таймаут PreToolUse сам по себе не блокирует.
- Фильтр `if` работает по принципу best effort; жёсткие запреты
  задавайте в [правах](2_configs_permissions.md).
- Matcher `Bash` не видит правки файлов через shell.
- Любой вывод профиля shell перед JSON ломает разбор молча.
- `Stop`-хук можно перекрыть после 8 блокировок подряд: проверяйте
  `stop_hook_active`.
- Hosted-инструменты Codex (например, веб-поиск) хуки не вызывают.
- Контроль организации: `allowManagedHooksOnly`, `disableAllHooks`,
  `allowedHttpHookUrls`.

Не запускайте полный набор тестов на каждом `Stop` без необходимости.

## Как проверить

Запустите скрипт вручную с тестовым JSON на stdin и проверьте код
выхода. Затем вызовите событие в безопасной сессии. Отключение:
уберите запись и начните новую сессию.
