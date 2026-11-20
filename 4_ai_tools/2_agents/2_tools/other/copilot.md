# GitHub Copilot (agent mode, cloud agent)

Закрытый, жив.

| Пункт | Факты |
| --- | --- |
| Инструкции | `.github/copilot-instructions.md`; `.github/instructions/NAME.instructions.md` (frontmatter `applyTo`, `excludeAgent`); `AGENTS.md` в любом месте (ближайший приоритетнее); один `CLAUDE.md` или `GEMINI.md` в корне |
| Права | VS Code: подтверждение вызовов инструментов. Cloud agent: песочница с firewall allowlist, сессии Actions до 59 минут; без write-доступа сессия только чтение. Статьи про Approvals и Agent Sandboxing не открылись (404) |
| MCP | Новый формат: `.mcp.json` в корне, `~/.copilot/mcp-config.json`, ключ `mcpServers` (`type`: stdio, http, sse). Устаревший: `.vscode/mcp.json`, ключ `servers`. Cloud agent: настройки MCP в репозитории |
| Hooks (preview) | `.github/hooks/*.json`, `~/.copilot/hooks/`; события `sessionStart`, `userPromptSubmitted`, `preToolUse`, `postToolUse`, `preCompact`, `subagentStart`, `agentStop`, `sessionEnd`. Hooks старого Local harness устарели, удаление запланировано на февраль 2027 |
| Skills | `SKILL.md` в `.github/skills/`, `~/.copilot/skills/` (читает также `.claude/`, `.agents/`) |
| Субагенты | Custom agents `.github/agents/NAME.agent.md` (name, description, tools, model, user-invocable, disable-model-invocation) |
| Свои модели | BYOK в VS Code: Custom Endpoint (Chat Completions, Responses, Messages), `chatLanguageModels.json`; Ollama через расширение; модель должна поддерживать tool calling |
| Тарифы | Free 0, Pro 10, Pro+ 39, Max 100 USD/мес; Business и Enterprise по запросу; расход в AI Credits (1 credit = 0,01 USD). Новый cloud-опыт для платных планов с 2026-10-28 |

Источники:
https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions,
https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent,
https://github.com/features/copilot/plans,
https://code.visualstudio.com/docs/agents/reference/mcp-configuration,
https://code.visualstudio.com/docs/copilot/customization/hooks
