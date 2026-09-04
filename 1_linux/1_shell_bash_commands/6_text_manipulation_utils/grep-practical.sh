# shellcheck shell=bash

# Additional practical grep examples. The original grep.sh remains unchanged.

# Literal word with filenames and line numbers; skip binary files and large trees.
grep -RInw \
  --exclude-dir=.git \
  --exclude-dir=node_modules \
  --exclude-dir=.venv \
  --fixed-strings -- 'connection refused' ./configs

# Search YAML files recursively. Repeat --include because grep globs have no braces.
grep -RIn \
  --include='*.yaml' \
  --include='*.yml' \
  --fixed-strings -- 'imagePullPolicy:' ./deploy

# Show only files containing a literal value.
grep -RIl --fixed-strings -- 'api.internal.example' ./deploy

# Count matching lines in each file and hide zero counts.
grep -RHcI --include='*.conf' --fixed-strings -- 'server_name' /etc/nginx \
  | grep -v ':0$'

# Show three surrounding lines for each error.
grep -nC 3 -E -- 'ERROR|FATAL|panic' /var/log/myapp/app.log

# Show active configuration: ignore blank lines and comments with leading spaces.
grep -Ev '^[[:space:]]*(#|;|$)' /etc/myapp/myapp.conf

# Match both conditions in any order by applying two independent filters.
grep -i -- 'timeout' /var/log/myapp/app.log | grep -i -- 'database'

# Process many files safely, including filenames with spaces.
find /var/log/myapp -type f -name '*.log' -print0 \
  | xargs -0 -r grep -nHI --fixed-strings -- 'request_id=example-id'

# Search rotated gzip logs without unpacking them on disk.
zgrep -nH -E -- ' 50[0-9] ' /var/log/nginx/access.log.*.gz

# Filter the systemd journal by several network failure symptoms.
journalctl -u myapp.service --since '2 hours ago' --no-pager \
  | grep -Ei -- 'timeout|connection reset|no route to host|temporary failure'

# Extract IPv4-looking values. This finds candidates; it does not validate 0..255.
grep -Eo -- '([0-9]{1,3}\.){3}[0-9]{1,3}' /var/log/myapp/app.log \
  | sort -u

# Quiet check for automation. grep returns 0=found, 1=not found, 2=error.
if grep -qF -- 'READY' /run/myapp/status; then
  printf 'application is ready\n'
fi

# ripgrep is normally faster for interactive recursive repository searches.
rg -n -F -g '*.tf' -g '!**/.terraform/**' -- '0.0.0.0/0' ./infrastructure
