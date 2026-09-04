#!/usr/bin/env bash
set -euo pipefail

# Local host preflight for monitoring checks, deploys and incident triage.
# Exit codes: 0=healthy, 1=warning, 2=critical or invalid invocation.

usage() {
  cat <<'EOF'
Usage: host_health.sh [-w PERCENT] [-c PERCENT] [SERVICE ...]

Checks block usage, inode usage and optional systemd services.

Examples:
  ./host_health.sh
  ./host_health.sh -w 80 -c 90 nginx sshd
EOF
}

warning=80
critical=90

while getopts ':w:c:h' option; do
  case "$option" in
    w) warning=$OPTARG ;;
    c) critical=$OPTARG ;;
    h) usage; exit 0 ;;
    :) printf 'missing value for -%s\n' "$OPTARG" >&2; usage >&2; exit 2 ;;
    \?) printf 'unknown option: -%s\n' "$OPTARG" >&2; usage >&2; exit 2 ;;
  esac
done
shift "$((OPTIND - 1))"

if [[ ! $warning =~ ^[0-9]+$ || ! $critical =~ ^[0-9]+$ ]] ||
   ((warning < 1 || warning >= critical || critical > 100)); then
  printf 'thresholds must satisfy 1 <= warning < critical <= 100\n' >&2
  exit 2
fi

status=0

raise_status() {
  local candidate=$1
  ((candidate > status)) && status=$candidate
  return 0
}

check_df() {
  local mode=$1 label=$2
  local filesystem capacity mountpoint percent severity

  while read -r filesystem _ _ _ capacity mountpoint; do
    [[ $capacity == *% ]] || continue
    percent=${capacity%%%}
    severity=OK
    if ((percent >= critical)); then
      severity=CRITICAL
      raise_status 2
    elif ((percent >= warning)); then
      severity=WARNING
      raise_status 1
    fi
    printf '%-8s %-8s %3s%% %s (%s)\n' "$severity" "$label" "$percent" "$mountpoint" "$filesystem"
  done < <(df "$mode" -x tmpfs -x devtmpfs 2>/dev/null | tail -n +2)
}

check_df -P disk
check_df -Pi inodes

if (($# > 0)); then
  if ! command -v systemctl >/dev/null 2>&1; then
    printf 'CRITICAL services systemctl is not available\n'
    raise_status 2
  else
    for service in "$@"; do
      if systemctl is-active --quiet "$service"; then
        printf 'OK       service  %s is active\n' "$service"
      else
        printf 'CRITICAL service  %s is not active\n' "$service"
        raise_status 2
      fi
    done
  fi
fi

exit "$status"
