# Safe File Operations

Two utilities cover repeatable operations where previews, predictable exit codes, and machine-readable results are important. Both use only the Python standard library and do not follow symbolic links by default.

```bash
cd 1_linux/3_scripts_bash_python/python
```

## Rename Extensions for a Group of Files

[`rename_extensions.py`](rename_extensions.py) builds a plan first. File names are not changed without `--apply`.

```bash
# View plan for files in the current directory only
./rename_extensions.py /var/tmp/reports --from .jpeg --to .jpg

# Multi-part extension and nested directories
./rename_extensions.py /var/tmp/logs \
  --from .old.log --to .log --recursive --json > /var/tmp/rename-plan.json

# Apply only after checking the preview
./rename_extensions.py /var/tmp/reports \
  --from .jpeg --to .jpg --apply
```

Extensions can be passed with or without a dot. Multi-part variants like `.old.log` are supported. `--ignore-case` allows `.JPEG`/`.jpeg` matches.
During recursive runs, `.git`, `.venv`, `node_modules`, and `__pycache__` are skipped. If the destination already exists or multiple sources yield the same target name, the entire operation is blocked before the first rename and returns exit code `1`. The script never intentionally overwrites an existing destination.

Exit code `0` means a valid preview or successful application, `2` — invalid input/I/O error, `3` — no suitable files. If a rare filesystem error occurs mid-application, some completed renames might remain; JSON/text output shows each file's status. Before reversing the rename, run a preview again with `--from` and `--to` swapped.

## Find Text Occurrences

For general interactive repository search, `rg` is faster. The utility [`text_search.py`](text_search.py) is useful for automation: it yields stable JSON Lines, limits file sizes and match counts, and skips binaries.

```bash
# Case-insensitive literal search
./text_search.py /var/log/myapp 'connection refused' --ignore-case

# Only a distinct word in YAML files
./text_search.py ./deploy deprecated \
  --word --glob '*.yaml' --glob '*.yml'

# Regex: find container images with latest
./text_search.py ./deploy 'image:.*:latest$' --regex --glob '*.yaml'

# Suppress potentially secret string output, save JSON Lines
./text_search.py ./exports password \
  --word --redact-line --jsonl > /var/tmp/password-locations.jsonl
```

By default, `.git`, `.venv`, `node_modules`, and `__pycache__` are excluded, symlinks are not followed, files larger than 10 MiB are skipped, and results are capped at 1000 matches. Limits can be changed via `--max-file-bytes` and `--max-matches`, and additional directories can be excluded using a repeatable `--exclude-dir`.

Exit codes: `0` — matches found, `1` — no matches, `2` — invalid input or partial read error. Normal output contains the full matched line; to search for secret parameter names, use `--redact-line`.
