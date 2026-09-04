# Безопасные операции с файлами

Две утилиты закрывают повторяемые операции, где важны preview, предсказуемые
коды возврата и машинный результат. Обе используют только Python standard
library и по умолчанию не переходят по symbolic links.

```bash
cd 1_linux/3_scripts_bash_python/python
```

## Заменить расширение у группы файлов

[`rename_extensions.py`](rename_extensions.py) сначала строит план. Без
`--apply` имена файлов не меняются.

```bash
# Посмотреть план для файлов только в текущем каталоге
./rename_extensions.py /var/tmp/reports --from .jpeg --to .jpg

# Multi-part extension и вложенные каталоги
./rename_extensions.py /var/tmp/logs \
  --from .old.log --to .log --recursive --json > /var/tmp/rename-plan.json

# Применить только после проверки preview
./rename_extensions.py /var/tmp/reports \
  --from .jpeg --to .jpg --apply
```

Расширения можно передавать с точкой или без неё. Поддерживаются multi-part
варианты вроде `.old.log`. `--ignore-case` разрешает совпадения `.JPEG`/`.jpeg`.
При рекурсивном запуске пропускаются `.git`, `.venv`, `node_modules` и
`__pycache__`. Если destination уже существует или несколько source дают одно
целевое имя, операция целиком блокируется до первого rename и возвращает код
`1`. Скрипт никогда намеренно не перезаписывает существующий destination.

Код `0` означает корректный preview или успешное применение, `2` — неверный
input/I/O error, `3` — подходящих файлов нет. При редкой ошибке файловой системы
в середине применения часть уже выполненных rename может остаться; JSON/text
output показывает статус каждого файла. Перед обратным rename снова запустите
preview с поменянными местами `--from` и `--to`.

## Найти вхождение текста

Для обычного интерактивного поиска по репозиторию быстрее `rg`. Утилита
[`text_search.py`](text_search.py) полезна для automation: она выдаёт стабильный
JSON Lines, ограничивает размер файлов и число совпадений, пропускает binary.

```bash
# Literal search без учёта регистра
./text_search.py /var/log/myapp 'connection refused' --ignore-case

# Только отдельное слово в YAML-файлах
./text_search.py ./deploy deprecated \
  --word --glob '*.yaml' --glob '*.yml'

# Regex: найти контейнерные images с latest
./text_search.py ./deploy 'image:.*:latest$' --regex --glob '*.yaml'

# Не выводить потенциально секретную строку, сохранить JSON Lines
./text_search.py ./exports password \
  --word --redact-line --jsonl > /var/tmp/password-locations.jsonl
```

По умолчанию исключены `.git`, `.venv`, `node_modules` и `__pycache__`, symlinks
не обходятся, файлы больше 10 MiB пропускаются, результат ограничен 1000
совпадениями. Лимиты меняются через `--max-file-bytes` и `--max-matches`, а
дополнительный каталог исключается повторяемым `--exclude-dir`.

Коды: `0` — совпадения найдены, `1` — совпадений нет, `2` — неверный input или
частичная ошибка чтения. Обычный output содержит всю найденную строку; для
поиска имён секретных параметров используйте `--redact-line`.
