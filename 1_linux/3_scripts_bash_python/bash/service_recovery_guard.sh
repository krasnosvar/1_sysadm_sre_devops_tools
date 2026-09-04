#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  service_recovery_guard.sh [OPTIONS] UNIT [-- HEALTH_COMMAND [ARG...]]

Check a systemd service and an optional application health command. When the
check fails, collect evidence before optionally performing one restart.

Options:
  --apply                 Restart the unit once after collecting evidence
  --grace SECONDS         Wait before the post-restart check (default: 3)
  --journal-since VALUE   journalctl --since value (default: "30 minutes ago")
  --output-parent DIR     Parent for the private evidence directory (default: .)
  -h, --help              Show help

Examples:
  ./service_recovery_guard.sh nginx
  ./service_recovery_guard.sh nginx -- curl --fail --max-time 5 \
    http://127.0.0.1/health
  sudo ./service_recovery_guard.sh --apply nginx -- \
    curl --fail --max-time 5 http://127.0.0.1/health

Exit codes:
  0  healthy before or after the optional restart
  1  unhealthy; evidence was collected
  2  invalid arguments or missing dependency
EOF
}

apply=false
grace=3
journal_since='30 minutes ago'
output_parent='.'
unit=''

while (($# > 0)); do
  case "$1" in
    --apply)
      apply=true
      shift
      ;;
    --grace)
      (($# >= 2)) || { printf 'ERROR: --grace requires a value\n' >&2; exit 2; }
      grace=$2
      shift 2
      ;;
    --journal-since)
      (($# >= 2)) || { printf 'ERROR: --journal-since requires a value\n' >&2; exit 2; }
      journal_since=$2
      shift 2
      ;;
    --output-parent)
      (($# >= 2)) || { printf 'ERROR: --output-parent requires a value\n' >&2; exit 2; }
      output_parent=$2
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      printf 'ERROR: UNIT must appear before --\n' >&2
      exit 2
      ;;
    -*)
      printf 'ERROR: unknown option: %s\n' "$1" >&2
      exit 2
      ;;
    *)
      unit=$1
      shift
      break
      ;;
  esac
done

[[ -n "$unit" ]] || { usage >&2; exit 2; }
[[ "$unit" =~ ^[A-Za-z0-9_.@:-]+$ ]] || {
  printf 'ERROR: unsupported systemd unit name: %s\n' "$unit" >&2
  exit 2
}
[[ "$grace" =~ ^[0-9]+$ ]] || {
  printf 'ERROR: --grace must be a non-negative integer\n' >&2
  exit 2
}
[[ -n "$output_parent" ]] || {
  printf 'ERROR: --output-parent must not be empty\n' >&2
  exit 2
}

if [[ ${1:-} == -- ]]; then
  shift
fi
health_command=("$@")

for dependency in systemctl journalctl; do
  command -v "$dependency" >/dev/null 2>&1 || {
    printf 'ERROR: required command is not installed: %s\n' "$dependency" >&2
    exit 2
  }
done
if ((${#health_command[@]} > 0)) && ! command -v "${health_command[0]}" >/dev/null 2>&1; then
  printf 'ERROR: health command is not installed or executable: %s\n' \
    "${health_command[0]}" >&2
  exit 2
fi

check_health() {
  systemctl is-active --quiet "$unit" || return 1
  if ((${#health_command[@]} > 0)); then
    "${health_command[@]}"
  fi
}

if check_health >/dev/null 2>&1; then
  printf 'HEALTHY: %s\n' "$unit"
  exit 0
fi

umask 077
timestamp=$(date -u +'%Y%m%dT%H%M%SZ')
evidence_dir="${output_parent%/}/service-recovery-${unit}-${timestamp}-$$"
if ! mkdir -p -- "$output_parent" || ! mkdir -- "$evidence_dir"; then
  printf 'ERROR: cannot create evidence directory: %s\n' "$evidence_dir" >&2
  exit 2
fi

capture() {
  local name=$1
  local exit_code
  shift
  {
    printf 'command:'
    printf ' %q' "$@"
    printf '\n'
    if "$@"; then
      exit_code=0
    else
      exit_code=$?
    fi
    printf '\nexit_code=%d\n' "$exit_code"
  } >"${evidence_dir}/${name}.txt" 2>&1
}

capture systemctl-status systemctl status --no-pager --full "$unit"
capture systemctl-show systemctl show \
  --property=Id,Names,LoadState,ActiveState,SubState,Result,MainPID,ExecMainStatus,NRestarts \
  "$unit"
capture journal journalctl --no-pager --unit "$unit" --since "$journal_since"
capture sockets ss -plntue

main_pid=$(systemctl show --property=MainPID --value "$unit" 2>/dev/null || true)
if [[ "$main_pid" =~ ^[1-9][0-9]*$ ]]; then
  capture process ps -ww -p "$main_pid" -o pid,ppid,user,stat,lstart,etime,%cpu,%mem,args
  if command -v pstree >/dev/null 2>&1; then
    capture process-tree pstree -alp "$main_pid"
  fi
  for proc_file in status limits cgroup; do
    if [[ -r "/proc/${main_pid}/${proc_file}" ]]; then
      capture "proc-${proc_file}" cat "/proc/${main_pid}/${proc_file}"
    fi
  done
fi

if ((${#health_command[@]} > 0)); then
  capture health-command "${health_command[@]}"
fi

printf 'UNHEALTHY: %s\n' "$unit" >&2
printf 'evidence: %s\n' "$evidence_dir" >&2

if [[ "$apply" != true ]]; then
  printf 'PREVIEW: restart was not attempted; pass --apply after reviewing evidence\n' >&2
  exit 1
fi

capture restart systemctl restart "$unit"
sleep "$grace"

if check_health >"${evidence_dir}/post-restart-health.txt" 2>&1; then
  printf 'RECOVERED: %s after one restart\n' "$unit"
  exit 0
fi

printf 'FAILED: %s is still unhealthy after one restart\n' "$unit" >&2
exit 1
