# Другие клиенты

Общие приёмы настройки: [1_setup](../../1_setup/README.md).

## Сводка

| Клиент | Инструкции | MCP | Hooks | Skills | Субагенты | Статус |
| --- | --- | --- | --- | --- | --- | --- |
| [Cursor](cursor.md) | `.cursor/rules`, AGENTS.md | да | да | да | да | закрытый |
| [GitHub Copilot](copilot.md) | `.github/copilot-instructions.md`, AGENTS.md | да | да (preview) | да | да | закрытый |
| [Aider](aider.md) | CONVENTIONS.md через `--read` | не проверено | не проверено | не проверено | режимы | Apache-2.0 |
| [opencode](opencode.md) | AGENTS.md | да | плагины | да | да | MIT |
| [Cline](cline.md) | `.clinerules/`, AGENTS.md | да | только SDK | да | не проверено | Apache-2.0 |
| [Windsurf (Devin Desktop)](windsurf.md) | AGENTS.md, `.devin/rules` | да | да | да | да | закрытый |

Тенденция: `SKILL.md` и AGENTS.md читаются почти всеми клиентами,
часть из них заодно читает каталоги `.claude/` и `.agents/`.
Переносимость правил и skills выше, чем у конфигов и hooks: форматы
hooks различаются. Сверяйте с версией клиента: документация
меняется (у Copilot старые hooks объявлены устаревшими).
