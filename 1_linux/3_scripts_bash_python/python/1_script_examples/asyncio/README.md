# Bounded Subprocess Runner

`shell_10_times.py` runs a single program multiple times with concurrency limits. The command is passed directly to the subprocess, without shell expansion.

```bash
./shell_10_times.py --count 10 --concurrency 3 -- psql -c 'select now()'
```

Do not pass passwords on the command line. Use `.pgpass`, process environment variables, or another native credential provider.
