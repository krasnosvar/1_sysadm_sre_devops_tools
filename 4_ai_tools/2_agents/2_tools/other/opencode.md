# opencode

MIT, открытый, жив. Последний релиз v1.19.6 от 2026-11-17. Документация
описывает формат «V2» (массив `permissions`, `mcp.servers`, `providers`);
совпадение с релизом 1.19.x не проверено, сверяйте на живой версии.

| Пункт | Факты |
| --- | --- |
| Инструкции | `AGENTS.md` основной (вверх от рабочей папки, вложенные подгружаются при чтении), `CLAUDE.md` как запасной; глобально `~/.config/opencode/AGENTS.md`; поле `instructions` в конфиге (пути, glob, URL) |
| Конфиг | `opencode.json` или `opencode.jsonc` в корне или `.opencode/`; глобально `~/.config/opencode/`; системный `/etc/opencode` (managed) |
| Права | Массив `permissions` из `{action, resource, effect: allow/deny/ask}`, побеждает последнее совпадение; `policies` для организации. Sandbox нет: shell с правами пользователя |
| MCP | `mcp.servers.<имя>`, `type`: local (command-массив, environment) или remote (url, headers, oauth); подстановка `{env:NAME}` |
| Плагины, skills | `plugins` в конфиге, автозагрузка `.opencode/plugins/`, `~/.config/opencode/plugins/`; имена событий не проверены. Skills: `SKILL.md` в `.opencode/skills`, `.claude/skills`, `.agents/skills`, `~/.config/opencode/skills` |
| Субагенты | Встроенные build, plan (primary), general, explore (subagent); свои в `.opencode/agents/<name>.md` или `agents` в конфиге |
| Свои модели | `providers.<id>` с openai-compatible, `settings.baseURL`, `models`; Ollama (127.0.0.1:11434), LM Studio (:1234/v1), vLLM (:8000/v1) обнаруживаются автоматически |

Источники: https://opencode.ai/docs/rules/, /config/, /permissions/,
/mcp-servers/, /plugins/, /skills/, /agents/, /providers/;
https://github.com/sst/opencode
