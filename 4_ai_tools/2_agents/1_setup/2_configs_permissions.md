# Конфиги, права и sandbox

Источники: https://code.claude.com/docs/en/permissions,
https://code.claude.com/docs/en/sandboxing,
https://learn.chatgpt.com/docs/sandboxing.md

## Claude Code: уровни настроек

`~/.claude/settings.json` (пользователь), `.claude/settings.json`
(проект, общий), `.claude/settings.local.json` (проект, личный),
`--settings` для одного запуска, managed settings организации.
Организационные выше остальных. Не заменяйте файл целиком: вносите
нужные ключи, сохраняя существующие.

## Режимы прав

| Режим | Смысл |
| --- | --- |
| `default` | Запрос на каждое чувствительное действие |
| `acceptEdits` | Правки файлов без запроса |
| `plan` | Только план, без изменений |
| `auto` | Фоновый classifier решает за вас |
| `dontAsk` | Без запросов, только разрешённое (в CLI) |
| `bypassPermissions` | Без запросов, включая `.git` и `.claude` |

`bypassPermissions` использовать только в изолированном контейнере или
ВМ. Отключить режимы можно ключами `permissions.disableBypassPermissionsMode`
и `permissions.disableAutoMode` со значением `"disable"`.

## Правила allow, ask, deny

Порядок: deny, затем ask, затем allow, первое совпадение решает.
Deny на любом уровне нельзя перекрыть другим, в том числе флагом
`--allowedTools`. Hook с allow не обходит deny и ask.

```json
{
  "permissions": {
    "allow": ["Bash(git status)", "Bash(git diff *)"],
    "deny": ["Read(./.env)", "Bash(rm -rf *)"]
  }
}
```

Синтаксис правил сверяйте с документацией своей версии.

## Sandbox

Sandbox ограничивает Bash на уровне ОС и дополняет права.
`sandbox.autoAllowBashIfSandboxed: true` пускает команды в sandbox
без запросов. Права и sandbox не заменяют друг друга.

## Организация

Ключ `allowManagedPermissionRulesOnly` оставляет managed-правила
единственным источником. `permissions.blockReadsOutsideWorkingDirectories`
блокирует чтение вне рабочих каталогов.

## Codex

`sandbox_mode`: `read-only`, `workspace-write`, `danger-full-access`.
`approval_policy`: `on-request`, `never`. `approvals_reviewer`:
`user` или `auto_review`. «Full access» это `danger-full-access` плюс
`never`. Защищённые пути (`.git`, `.agents`, `.codex`) на официальной
странице не описаны: не проверено.

Gemini CLI: права и sandbox не исследовались, не проверено.

## Как проверить и откатить

Сохраните исходный файл, измените один ключ, начните новую сессию,
проверьте поведение на безопасном запросе. Откат: вернуть файл и
начать новую сессию.
