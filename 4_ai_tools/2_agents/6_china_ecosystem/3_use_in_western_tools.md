# Подключение к привычным агентам

Ключи ниже заменены плейсхолдерами. Не коммитьте реальные ключи и не кладите их
в публичные файлы.

Предпосылка: Claude Code установлен, есть ключ API вендора. Сначала
проверьте на тестовом репозитории без рабочего кода. Откат: удалить
переменные и начать новую сессию.

## Z.ai (GLM)

Документация: https://docs.z.ai/devpack/tool/claude

```bash
export ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"
export ANTHROPIC_AUTH_TOKEN="<ключ Z.ai>"
export API_TIMEOUT_MS=3000000
```

Модели Opus, Sonnet, Haiku сопоставляются с `GLM-5.3-Flash` или
`glm-5.3[1m]`. Документация противоречива в выборе соответствия,
сверьтесь со страницей. Скрипт установки только для macOS и Linux.
Для протокола OpenAI указан `https://api.z.ai/api/coding/paas/v4`
(https://docs.z.ai/devpack/tool/others.md).

## Moonshot (Kimi)

Документация: https://platform.kimi.ai/docs/guide/claude-code-kimi.md

```bash
export ANTHROPIC_BASE_URL="https://api.moonshot.ai/anthropic"
export ANTHROPIC_AUTH_TOKEN="<ключ Moonshot>"
unset ANTHROPIC_API_KEY
```

- Нужно явно задать модели для всех уровней и для субагентов
  (`CLAUDE_CODE_SUBAGENT_MODEL`), иначе фоновые задачи и субагенты
  падают. Список переменных смотрите в документации вендора.
- Ключ и базовый URL должны быть с одной платформы, иначе 401.
- Значения в `settings.json` перекрывают переменные оболочки.

## DeepSeek

Документация: https://api-docs.deepseek.com/guides/anthropic_api

```bash
export ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"
export ANTHROPIC_AUTH_TOKEN="<ключ DeepSeek>"
```

- Модели `claude-opus*` направляются на `deepseek-v4-pro`, остальные
  `claude*` на `deepseek-flash`.
- Игнорируются `cache_control`, `budget_tokens` и MCP-блоки.
- `deepseek-v4-pro` не принимает изображения.

## opencode

https://opencode.ai/docs/providers/

Провайдеры задаются в `opencode.jsonc`. Поддерживаются Ollama
(автообнаружение на локальном порту 11434) и OpenRouter
(`OPENROUTER_API_KEY`). Отдельных записей для китайских вендоров нет:
подключайте через openai-compatible провайдер.


## Локальный запуск

На страницах Kimi, GLM и MiniMax указаны vLLM, SGLang, llama.cpp,
Ollama. Флагманы (428B-2.8T параметров) без кластера не запустить.
Для локальной работы выбирайте компактные варианты (например, Qwen
27B) и проверяйте на своих задачах.

## Типичные ошибки

- 401: ключ и базовый URL от разных платформ.
- Субагенты и фоновые задачи падают: не заданы модели для всех
  уровней.
- Неожиданные модели: настройки в `settings.json` перекрывают
  окружение.
- Часть возможностей Anthropic API не поддерживается эндпоинтом
  (кэширование, thinking, изображения). Проверяйте в документации.
