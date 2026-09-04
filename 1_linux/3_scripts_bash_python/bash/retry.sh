#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: retry.sh [-a ATTEMPTS] [-d INITIAL_DELAY] [-m MAX_DELAY] -- COMMAND [ARG...]

Retry a command with capped exponential backoff. The command is invoked
directly, without eval or an extra shell.

Examples:
  ./retry.sh -- curl --fail --silent --show-error https://example.com/health
  ./retry.sh -a 6 -d 2 -m 20 -- kubectl rollout status deploy/api --timeout=30s
EOF
}

attempts=5
delay=1
max_delay=30

while getopts ':a:d:m:h' option; do
  case "$option" in
    a) attempts=$OPTARG ;;
    d) delay=$OPTARG ;;
    m) max_delay=$OPTARG ;;
    h) usage; exit 0 ;;
    :) printf 'ERROR: -%s requires a value\n' "$OPTARG" >&2; exit 2 ;;
    ?) printf 'ERROR: unknown option: -%s\n' "$OPTARG" >&2; exit 2 ;;
  esac
done
shift "$((OPTIND - 1))"
[[ ${1:-} == -- ]] && shift

[[ "$attempts" =~ ^[1-9][0-9]*$ ]] || { printf 'ERROR: attempts must be positive\n' >&2; exit 2; }
[[ "$delay" =~ ^[0-9]+$ ]] || { printf 'ERROR: delay must be a non-negative integer\n' >&2; exit 2; }
[[ "$max_delay" =~ ^[1-9][0-9]*$ ]] || { printf 'ERROR: max delay must be positive\n' >&2; exit 2; }
(($# > 0)) || { usage >&2; exit 2; }

for ((attempt = 1; attempt <= attempts; attempt++)); do
  if "$@"; then
    exit 0
  else
    exit_code=$?
  fi

  if ((exit_code >= 128 || attempt == attempts)); then
    printf 'FAILED: command exited %d after %d attempt(s)\n' "$exit_code" "$attempt" >&2
    exit "$exit_code"
  fi

  printf 'WARN: attempt %d/%d exited %d; retrying in %ds\n' \
    "$attempt" "$attempts" "$exit_code" "$delay" >&2
  sleep "$delay"
  delay=$((delay * 2))
  ((delay > max_delay)) && delay=$max_delay
done
