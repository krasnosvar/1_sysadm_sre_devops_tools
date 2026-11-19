# Windsurf (теперь Devin Desktop)

Переименован в Devin Desktop 2026-06-02 (Cognition). Локальный агент Devin Local
заменяет Cascade; memories и workflows заменены на rules и skills. Тарифы и
настройки сохранены, точная цена не проверена. Закрытый. docs.windsurf.com
перенаправляет на https://docs.devin.ai. Даты окончания Cascade из вторичных
источников в первичных не подтверждены.

| Пункт | Факты |
| --- | --- |
| Инструкции | `AGENTS.md`, `AGENTS.local.md`, `AGENT.md` (от корня до рабочей папки); `.devin/rules/*.md` (trigger: always_on, glob, model_decision, manual); `~/.devin/rules/`; прежние `.windsurf/rules/` и `.windsurfrules` импортируются |
| Права | Права и sandbox Devin Local не проверены (страница 404); hooks не работают в Restricted Mode |
| MCP | `.devin/mcp_config.json`, `.devin/mcp_config.local.json` (не в git), `~/.config/devin/mcp_config.json`; ключ `mcpServers`; stdio и HTTP (`transport` http или sse, headers, oauth); `${env:VAR}` |
| Hooks | `.devin/hooks.v1.json`; события `PreToolUse`, `PostToolUse`, `PermissionRequest`, `UserPromptSubmit`, `Stop`, `PostCompaction`, `SessionStart`, `SessionEnd` (по документации CLI); код 2 блокирует |
| Skills | `SKILL.md` в `.devin/skills/`, `.agents/skills/`, `~/.config/devin/skills/` |
| Субагенты | Есть (вкладка Subagents, плагины дают субагентов); формат файлов не проверен |
| Свои модели | BYOK и OpenAI-совместимые: не проверено |

Источники: https://docs.devin.ai/desktop/devin-desktop-faq,
/desktop/cascade/mcp, /desktop/cascade/hooks, /desktop/cascade/skills,
https://docs.devin.ai/cli/extensibility/mcp/configuration.md
