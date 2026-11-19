# Cursor

Закрытый, жив. docs.cursor.com перенаправляет на https://cursor.com/docs.

| Пункт | Факты |
| --- | --- |
| Инструкции | `.cursor/rules/*.mdc` (только `.mdc` с frontmatter, `.md` игнорируется); типы: Always, Intelligently, Specific Files, Manually. AGENTS.md в корне и подпапках, ближайший приоритетнее |
| Права | Режимы (Settings, Agents, Approvals and Execution): Auto-review (рекомендован), Allowlist, Run Everything. `.cursor/sandbox.json` и `~/.cursor/sandbox.json`; `.cursor/permissions.json`; `.cursorignore`. Документация: не жёсткая граница безопасности |
| MCP | `.cursor/mcp.json`, `~/.cursor/mcp.json`, ключ `mcpServers`; stdio, SSE, Streamable HTTP; `${env:NAME}`, `${workspaceFolder}` |
| Hooks | `.cursor/hooks.json`, `~/.cursor/hooks.json`; `{"version":1,"hooks":{...}}`; события `preToolUse`, `postToolUse`, `beforeShellExecution`, `beforeReadFile`, `afterFileEdit`, `stop` и другие; код выхода 2 блокирует |
| Skills | `SKILL.md` в `.cursor/skills/`, `.agents/skills/`; читает также `.claude/` и `.codex/` |
| Субагенты | `.cursor/agents/`, `.claude/agents/`, `.codex/agents/` (md с frontmatter: name, description, model, readonly, is_background); встроенные Explore, Browser |
| Свои модели | Ключи OpenAI, Anthropic, Google, Azure OpenAI, AWS Bedrock; только чат, не Tab; запросы идут через бэкенд Cursor. Свой Base URL и локальные модели не проверены |
| Тарифы | Free 0, Plus 8, Premium 30, Super 100, Ultra 200 USD/мес; Teams 30/100/200 за место. Страница моделей называет Hobby, Pro, Pro+ устаревшими |

Источники: https://cursor.com/docs/context/rules,
https://cursor.com/docs/context/mcp, https://cursor.com/docs/hooks,
https://cursor.com/docs/skills, https://cursor.com/docs/subagents,
https://cursor.com/docs/agent/run-modes, https://cursor.com/pricing
