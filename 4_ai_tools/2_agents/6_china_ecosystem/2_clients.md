# Агентные клиенты и IDE

## Qwen Code

https://github.com/QwenLM/qwen-code

- Лицензия Apache-2.0, форк Gemini CLI v0.8.2.
- Установка: `npm i -g @qwen-code/qwen-code@latest` (нужен Node 22+),
  также `brew install qwen-code` и установочный скрипт.
- Работает с API OpenAI, Anthropic, Gemini и Qwen, а также с
  локальными Ollama и vLLM.

## Kimi CLI

https://github.com/MoonshotAI/kimi-cli

- Лицензия Apache-2.0. Репозиторий заархивирован, преемник Kimi Code
  CLI. По документации старые установки перестанут работать.
- Установка преемника: `brew install kimi-code` или
  `npm i -g @moonshot-ai/kimi-code`. Установочный скрипт с сайта
  вендора перед запуском прочитайте, а не выполняйте вслепую.

## Trae (ByteDance)

Форк VS Code. В 2025 году описан конфликт: данные уходили при
выключенном переключателе телеметрии. По ответу ByteDance
переключатель управляет только телеметрией каркаса VS Code.
https://www.theregister.com/2025/07/28/bytedance_trae_telemetry/
Прочие утверждения (например, срок хранения данных) не проверены.


## Как выбирать

Если нужен знакомый агент, проще подключить китайскую модель к уже
используемому клиенту ([файл 3](3_use_in_western_tools.md)). Отдельный
клиент даёт смысл, когда он лучше настроен под конкретную модель.
