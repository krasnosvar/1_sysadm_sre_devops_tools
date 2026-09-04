# xargs: build safe command batches from stdin.

# Put account names on one line.
cut -d: -f1 /etc/passwd | sort | xargs

# Filenames may contain spaces/newlines: pair find -print0 with xargs -0.
find ./logs -type f -name '*.log' -print0 | xargs -0 -r gzip --
find ./config -type f -name '*.yaml' -print0 | xargs -0 -r grep -HnF 'image: latest'

# Replace a placeholder and limit the batch size.
printf '%s\n' host-a host-b | xargs -r -I{} ssh -- '{}' uptime
printf '%s\n' file-a file-b file-c | xargs -r -n2 printf 'batch: %s %s\n'

# Bounded parallelism for independent read-only checks.
printf '%s\n' https://example.com/health https://example.net/health | \
  xargs -r -n1 -P4 curl --fail --silent --show-error --max-time 5 --output /dev/null

# Ask before a destructive operation. Review the generated paths first.
find ./cache -type f -mtime +30 -print0 | xargs -0 -r -p rm --

# GNU xargs: -r avoids invoking the command for empty input.
# BSD/macOS xargs already skips empty input for most commands and may not support -r.
