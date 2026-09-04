# Bounded subprocess runner

`shell_10_times.py` запускает одну программу несколько раз с ограничением
параллелизма. Команда передаётся напрямую в subprocess, без shell expansion.

```bash
./shell_10_times.py --count 10 --concurrency 3 -- psql -c 'select now()'
```

Пароли в командной строке не передавать. Использовать `.pgpass`, переменные
окружения процесса или другой нативный credential provider.
