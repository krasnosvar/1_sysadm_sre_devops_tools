# Cline

Apache-2.0, жив; плагин для JetBrains закрыт. Последний релиз v4.1.26 от
2026-10-26. Цены: не проверено.

| Пункт | Факты |
| --- | --- |
| Инструкции | `.clinerules/` или `.cline/rules/` (md, опционально frontmatter `paths`); глобально `~/.cline/rules`; читает `.cursorrules` и `.windsurfrules`; AGENTS.md в корне и `~/.agents/AGENTS.md` |
| Права | Переключатели auto-approve (чтение и правка внутри и вне проекта, команды safe или all, браузер, MCP); модель помечает команды, требующие подтверждения; YOLO mode отключает все проверки. Файл прав и sandbox не проверены |
| MCP | CLI: `~/.cline/data/settings/cline_mcp_settings.json` (или `CLINE_MCP_SETTINGS_PATH`); IDE: панель MCP Servers; ключ `mcpServers`; stdio (command, args, env, disabled, autoApprove), remote `streamableHttp` или `sse` |
| Skills | `SKILL.md` в `.cline/skills/`, `.clinerules/skills/`, `.claude/skills/`, `~/.cline/skills/` |
| Hooks | Описаны только в SDK как плагины (`beforeRun`, `afterRun`, `beforeModel`, `afterModel`, `beforeTool`, `afterTool`, `onEvent`; таймаут 3 с); файловые hooks IDE не проверены |
| Режимы | Plan и Act (раздельные модели), `/deep-planning`; субагенты и свои режимы не проверены |
| Свои модели | Provider «OpenAI Compatible»: Base URL, API Key, Model ID; Ollama и LM Studio поддерживаются |

Источники: https://docs.cline.bot/customization/cline-rules,
/customization/skills, /mcp/configuring-mcp-servers,
/features/auto-approve, /features/plan-and-act,
/provider-config/openai-compatible; https://github.com/cline/cline
