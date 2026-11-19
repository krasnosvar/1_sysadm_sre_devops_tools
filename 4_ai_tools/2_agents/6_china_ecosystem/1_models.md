# Модели

## Сводка

| Лаборатория | Свежие модели (приблизительно) | Веса | Лицензия |
| --- | --- | --- | --- |
| Moonshot (Kimi) | K3.1 Pro (начало ноября 2026), K3 (сентябрь) | открыты | своя |
| Z.ai (GLM) | GLM-5.3, 5.3-Flash (середина октября 2026) | открыты | своя |
| Alibaba (Qwen) | семейство Qwen3.8 (около 7 ноября 2026) | открыты | своя |
| DeepSeek | V4.1-Flash, V4-Pro | не проверено | не проверено |
| MiniMax | M3 (конец октября), M3.1-Flash (начало ноября) | открыты | community |
| ByteDance (Doubao) | Doubao-Seed-Code (ноябрь 2025) | не проверено | не проверено |

Лицензии кастомные: условия коммерческого использования не читались.
Перед внедрением откройте файл LICENSE конкретной модели.

## Kimi (Moonshot)

Источник: https://huggingface.co/moonshotai

- K3.1 Pro: MoE 2.8T параметров, активных 104B, контекст 1M.
  Заявлено: Terminal-Bench 4.0 65.7, DeepSWE v1.1 75.5.
  https://huggingface.co/moonshotai/Kimi-K3.1-Pro
- K3: заявлено Terminal-Bench 2.1 88.3, OSWorld-Verified 84.8.
  https://huggingface.co/moonshotai/Kimi-K3
- API: `kimi-k3.1-pro`, `kimi-k3.1-pro-highspeed`, контекст 1M.
  https://platform.kimi.ai/docs/guide/agent-support
- Цена API: не проверено.

## GLM (Z.ai)

Источник: https://huggingface.co/zai-org

- GLM-5.3: 753B, открытые веса. Заявлено: Terminal Bench 2.1 88.2,
  DeepSWE 66.9, NL2Repo 58.0. SWE-bench Verified на странице нет.
  https://huggingface.co/zai-org/GLM-5.3
- Цена API: не проверено.

## Qwen (Alibaba)

Источник: https://huggingface.co/Qwen

- Qwen3.8-2.4T-A95B: контекст 262K (расширяется до 1.01M),
  заявлено SWE-bench Pro 67.7.
  https://huggingface.co/Qwen/Qwen3.8-2.4T-A95B
- На OpenRouter встречалась запись `qwen/qwen4-max`, подтверждения
  от Alibaba не найдено. Не использовать как факт.
- Предыдущее поколение кодовых моделей (Qwen3-Coder, июль 2025,
  480B-A35B) известно по вторичным источникам.

## DeepSeek

Цены: https://api-docs.deepseek.com/quick_start/pricing

- Модели API: `deepseek-flash` и `deepseek-v4-pro`, контекст 1M,
  вывод до 384K.
- Цена за 1M токенов (внепиковая / пиковая), вход без кэша:

| Модель | Вход | Вывод |
| --- | --- | --- |
| flash | $0.15 / $0.30 | $0.6 / $1.2 |
| v4-pro | $0.66 / $1.32 | $1.98 / $3.96 |

- Пик: будни 01-04 и 06-10 UTC.
- Результат SWE-bench 80.6% для V4-Pro известен только по вторичным
  источникам, не проверено. Лицензию весов не проверяли.
- Сообщение о повышении цен в августе 2026 (вторичный источник):
  https://the-decoder.com/deepseek-launches-an-improved-v4-pro-model-raises-API-prices-and-makes-its-agent-software-open-source/

## MiniMax

Источник: https://huggingface.co/MiniMaxAI

- M3: MoE 428B, активных 23B, контекст 1M, лицензия
  minimax-community. Заявлено SWE-bench Verified 80.5, методика
  не указана. https://huggingface.co/MiniMaxAI/MiniMax-M3
- Вторичный источник сообщает о смене лицензии M2.7 на разрешение
  в письменной форме для коммерческого использования:
  https://decrypt.co/364225/minimax-m27-agent-model-license-change
  Первоисточник не проверен.
- Цена: не проверено.

## Doubao (ByteDance)

Doubao-Seed-Code (ноябрь 2025): только вторичные источники. Открытость
весов, версии, цена и бенчмарки: не проверено.

## Независимые рейтинги

[Aider polyglot](https://aider.chat/docs/leaderboards/) обновлялся
2025-11-20 и устарел: моделей 2026 года там нет. Лучшие китайские
результаты на нём: DeepSeek-V3.2-Exp Reasoner 74.2% (2025-10-03),
Kimi K2 59.1% (2025-07-17). LiveCodeBench для перечисленных моделей:
не проверено.
