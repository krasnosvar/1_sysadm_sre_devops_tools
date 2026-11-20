# Aider

Apache-2.0, открытый, не архивирован. Последний релиз v0.86.0 от 2025-08-09:
больше трёх месяцев без релизов, риск замедления разработки.

| Пункт | Факты |
| --- | --- |
| Инструкции | Отдельного файла нет: `CONVENTIONS.md` подключается через `--read`, `/read` или `read:` в `.aider.conf.yml`. Поддержка AGENTS.md не проверена |
| Конфиг | `.aider.conf.yml` в домашнем каталоге, корне git и текущей папке (последний важнее); `.env`; `.aider.model.settings.yml`, `.aider.model.metadata.json` |
| Права, sandbox | В проверенных страницах не найдены, не проверено |
| MCP, hooks, skills | В проверенных страницах не упомянуты, не проверено |
| Режимы | code, ask, architect (две модели), help |
| Свои модели | OpenAI-совместимые: `OPENAI_API_BASE`, `OPENAI_API_KEY`, `--model openai/<имя>`; страница про Ollama не читалась |

Источники: https://aider.chat/docs/usage/conventions.html,
https://aider.chat/docs/config/aider_conf.html,
https://aider.chat/docs/llms/openai-compat.html,
https://aider.chat/docs/usage/modes.html,
https://github.com/Aider-AI/aider
