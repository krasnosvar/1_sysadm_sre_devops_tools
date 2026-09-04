#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: nginx_access_report.sh [--top N] [ACCESS_LOG|-]

Summarize an nginx/Apache combined access log without loading it into memory.
The default input is stdin. Output includes status codes, client IPs and paths.

Examples:
  ./nginx_access_report.sh /var/log/nginx/access.log
  zcat /var/log/nginx/access.log.1.gz | ./nginx_access_report.sh --top 20
  kubectl logs deploy/ingress-nginx | ./nginx_access_report.sh -
EOF
}

top=10
input=-
input_set=0

while (($#)); do
  case "$1" in
    --top)
      [[ $# -ge 2 ]] || { printf 'ERROR: --top requires a value\n' >&2; exit 2; }
      top=$2
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    -)
      ((input_set == 0)) || { printf 'ERROR: only one input is allowed\n' >&2; exit 2; }
      input=-
      input_set=1
      shift
      ;;
    --*)
      printf 'ERROR: unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
    *)
      ((input_set == 0)) || { printf 'ERROR: only one input is allowed\n' >&2; exit 2; }
      input=$1
      input_set=1
      shift
      ;;
  esac
done

[[ "$top" =~ ^[1-9][0-9]*$ ]] || { printf 'ERROR: --top must be a positive integer\n' >&2; exit 2; }
[[ "$input" == - || -r "$input" ]] || { printf 'ERROR: cannot read %s\n' "$input" >&2; exit 2; }

work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT INT TERM

LC_ALL=C awk -v output_dir="$work_dir" '
  $9 ~ /^[1-5][0-9][0-9]$/ {
    status[$9]++
    clients[$1]++
    paths[$7]++
    valid++
    next
  }
  { malformed++ }
  END {
    for (key in status)  print status[key], key > output_dir "/status"
    for (key in clients) print clients[key], key > output_dir "/clients"
    for (key in paths)   print paths[key], key > output_dir "/paths"
    print valid + 0, malformed + 0 > output_dir "/totals"
  }
' "$input"

read -r valid malformed < "$work_dir/totals"
printf 'Requests: %s (ignored malformed lines: %s)\n' "$valid" "$malformed"

print_top() {
  local title=$1 file=$2
  printf '\n%s\n' "$title"
  if [[ -s "$file" ]]; then
    sort -k1,1nr -k2,2 "$file" | sed -n "1,${top}p"
  else
    printf '0 -\n'
  fi
}

print_top 'Top status codes (count status)' "$work_dir/status"
print_top 'Top client IPs (count address)' "$work_dir/clients"
print_top 'Top request paths (count path)' "$work_dir/paths"
