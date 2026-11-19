# ИИ-приложения для повседневной работы (кроме агентов)

По одному самому ходовому сервису на задачу. Больше вариантов:
[каталог инструментов](../1_tools_catalog/README.md). Агенты для кодинга:
[2_agents](../2_agents/README.md). Цены на 2026-11-19, перед покупкой
сверяйте со страницей сервиса.

| Задача | Сервис | Что делает | Тариф | Данные | Источник |
| --- | --- | --- | --- | --- | --- |
| Новости | Feedly | RSS и ИИ-фильтры (Leo) | Free, Pro, Pro+; Leo в Pro+ | Облако | https://feedly.com/pricing |
| Календарь и задачи | Reclaim.ai | Раскладывает задачи по окнам, защищает время | Lite бесплатно; Starter $10, Business $15 (год) | Облако | https://reclaim.ai/pricing |
| Почта | Gmail с Gemini | Сводки, помощь с письмами и расписанием | Нужен Google AI Plus, Pro, Ultra или подходящий Workspace | Workspace: без обучения на ваших данных | https://support.google.com/mail/answer/16831098 |
| Встречи | Otter | Расшифровка и сводки | Basic бесплатно (300 мин); Pro $8,33 (год) | Облако | https://otter.ai/pricing |
| Заметки | Obsidian | Локальные markdown-заметки | Приложение бесплатно; Sync $4 (год) | Файлы у вас | https://obsidian.md/pricing |
| Исследования | Elicit | Поиск и обзор научных статей | Basic бесплатно; Pro $49 | Облако | https://elicit.com/pricing |
| Документы и слайды | Microsoft 365 Copilot | Word, Excel, PowerPoint | Add-on около $21 за место в месяц | Не обучает базовые модели (Enterprise Data Protection) | https://www.microsoft.com/en-us/microsoft-365-copilot/pricing |
| Данные | Metabase | BI и вопросы к данным, свой ключ модели | Open Source бесплатно (AGPL); Starter $100/мес | Самохостинг или облако | https://www.metabase.com/pricing |
| Автоматизация | Zapier | Связки сервисов с ИИ-шагами | Free 100 задач/мес; Pro от $19,99 (год) | Облако | https://zapier.com/pricing |
| Браузер | Opera Neon | Агентный браузер | $19,90/мес | Пароли и cookies на устройстве, без обучения на данных | https://operaneon.com |
| Перевод | DeepL | Перевод и правка текста | Free 50K символов/мес; Pro платные | Pro: без обучения, Free не подтверждено | https://www.deepl.com/en/pro |
| Обучение | Anki | Интервальные повторения, алгоритм FSRS | Бесплатно (открытый код) | Локально | https://docs.ankiweb.net/deck-options.html |
| Самохостинг | Ollama | Локальный запуск моделей | MIT | Всё локально | https://github.com/ollama/ollama |

## Региональные

- Россия: Алиса от Яндекса. Голосовые записи идут на серверы Яндекса и
  могут передаваться сотрудникам и подрядчикам для анализа. Приоритет и
  бессрочное хранение чатов в опции «Алиса Плюс».
  https://yandex.ru/legal/alice_termsofuse/
- Китай: Kimi. Политика от 2026-08-04, отдельный раздел об использовании за
  рубежом. API оформляется на сингапурскую компанию. Модели для разработки:
  [China ecosystem](../2_agents/6_china_ecosystem/README.md).

## Политики данных основных сервисов

| Сервис | Обучение на данных | Хранение | Источник |
| --- | --- | --- | --- |
| Anthropic | Возможно, если не отключено в настройках | Удалённые чаты стираются до 30 дней | https://www.anthropic.com/legal/privacy |
| Google Gemini | Зависит от Gemini History: включена, значит возможно | 18 месяцев по умолчанию; выключена: около 2 месяцев | https://support.google.com/gemini/answer/13594961 |
| Microsoft Copilot (личный) | Включено для вошедших, можно отключить | 18 месяцев | https://support.microsoft.com/topic/27b3a435-8dc9-4b55-9a4b-58eeb9647a7f |
| Perplexity | Включено по умолчанию на Free, Pro, Max, отключается | Enterprise: файлы 7 дней | https://www.perplexity.ai/help-center/en/articles/11564572 |
| DeepSeek | Данные для улучшения моделей | В КНР, пока есть аккаунт | https://cdn.deepseek.com/policies/en-US/deepseek-privacy-policy.html |

Не отправляйте в облачные сервисы пароли, ключи, персональные и
медицинские данные, материалы под NDA. Для чувствительных данных
запускайте модель локально.
