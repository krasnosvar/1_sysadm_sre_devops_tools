# Skills

Источники: https://code.claude.com/docs/en/skills,
https://learn.chatgpt.com/docs/build-skills.md,
https://geminicli.com/docs/cli/skills/

## Что это

Каталог с файлом `SKILL.md`: YAML-frontmatter, затем инструкции. В
контекст сначала попадают только имя и описание, тело грузится при
использовании (progressive disclosure). Skill хранит повторяемый
процесс, а не постоянное правило.

## Где лежат

| Клиент | Места |
| --- | --- |
| Claude Code | `~/.claude/skills/<name>/`, `.claude/skills/<name>/`, `skills/` плагина, enterprise |
| Codex | `.agents/skills` от текущего каталога до корня репозитория, `$HOME/.agents/skills` |
| Gemini CLI | `~/.gemini/skills/` или `~/.agents/skills/`, в проекте `.gemini/skills/` |

При конфликте имён в Claude Code: enterprise выше personal, personal
выше project.

## Формат (Claude Code)

Все поля frontmatter необязательны, но `description` рекомендуется.
Поля: `name`, `description`, `when_to_use`, `argument-hint`,
`disable-model-invocation`, `user-invocable`, `allowed-tools`,
`context`, `paths`, `model`, `effort`. Вне Claude Code (claude.ai,
Skills API) принимается узкий набор: `name`, `description`, `license`,
`compatibility`, `metadata`, `allowed-tools`; остальные дают ошибку.

## Пример

```text
---
name: release-notes
description: Готовит черновик release notes из git log. Применять,
  когда просят описать изменения между тегами.
---
1. Получить коммиты: git log <prev>..<tag> --oneline.
2. Сгруппировать по типу, убрать служебные.
3. Вывести список в Markdown, без выдуманных деталей.
```

## Как писать description

Описывайте, что делает skill и когда его применять; главный сценарий
первым. Description и when_to_use вместе обрезаются на 1536 символах
в списке. В Codex бюджет списка skills около 2% контекста.

## Размер и структура

Тело SKILL.md держать меньше 500 строк. Детали выносить в
`reference.md`, `examples.md`, `scripts/`: они грузятся по
необходимости. После компакции тела skills подставляются заново с
лимитом 5000 токенов на skill и 25000 всего.

## Риски и проверка

Skill с `scripts/` исполняет код: читайте перед установкой чужих.
Проверьте: имя видно в списке, вызов срабатывает по описанию и по
имени, тело не противоречит инструкциям проекта. Подстановка
`!`команда`` выполняется до того, как модель увидит текст.
