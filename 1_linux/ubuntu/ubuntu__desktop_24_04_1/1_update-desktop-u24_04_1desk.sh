#!/usr/bin/env bash
set -euo pipefail

# Compact Ubuntu 24.04 workstation bootstrap. Large installer manifests belong
# to 2_lin_win_mac_apps_bkp; this script keeps a supported operational baseline.

profile=""
dry_run=0
check_only=0
failed=()

usage() {
  cat <<'EOF'
Usage: 1_update-desktop-u24_04_1desk.sh PROFILE [--dry-run]

Profiles: --minimal, --devops, --desktop, --all
Other:    --check, --dry-run, --help
EOF
}

for argument in "$@"; do
  case "$argument" in
    --minimal|--devops|--desktop|--all)
      [ -z "$profile" ] || { echo "choose exactly one profile" >&2; exit 2; }
      profile="${argument#--}"
      ;;
    --dry-run) dry_run=1 ;;
    --check) check_only=1 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "unknown option: $argument" >&2; usage >&2; exit 2 ;;
  esac
done

if [ "$check_only" -eq 0 ] && [ -z "$profile" ]; then
  echo "a profile is required" >&2
  usage >&2
  exit 2
fi

# shellcheck disable=SC1091
. /etc/os-release
if [ "${ID:-}" != ubuntu ] || [ "${VERSION_ID:-}" != 24.04 ]; then
  echo "this script supports Ubuntu 24.04; found ${PRETTY_NAME:-unknown}" >&2
  exit 2
fi

if [ "$check_only" -eq 1 ]; then
  for command_name in apt-get dpkg snap curl git; do
    if command -v "$command_name" >/dev/null 2>&1; then
      printf 'OK: %s\n' "$command_name"
    else
      printf 'MISSING: %s\n' "$command_name" >&2
      failed+=("command:$command_name")
    fi
  done
  [ "${#failed[@]}" -eq 0 ]
  exit $?
fi

run() {
  if [ "$dry_run" -eq 1 ]; then
    printf '+'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

minimal_packages=(
  ca-certificates curl git gnupg jq unzip zip rsync openssh-client
  ripgrep fd-find fzf bat eza zoxide direnv tree tmux htop btop ncdu
  shellcheck python3 python3-venv pipx golang-go
)
devops_packages=(
  ansible yamllint podman docker.io skopeo
  nmap tcpdump tshark mtr-tiny dnsutils iperf3 socat whois
  smartmontools sysstat iotop lsof strace
  rclone restic age
  postgresql-client redis-tools
)
desktop_packages=(
  keepassxc vlc libreoffice gimp inkscape flameshot remmina
  virt-manager qemu-kvm libvirt-daemon-system
)

packages=("${minimal_packages[@]}")
case "$profile" in
  devops) packages+=("${devops_packages[@]}") ;;
  desktop) packages+=("${desktop_packages[@]}") ;;
  all) packages+=("${devops_packages[@]}" "${desktop_packages[@]}") ;;
esac

run sudo apt-get update
available=()
for package in "${packages[@]}"; do
  if dpkg-query -W -f='${db:Status-Status}' "$package" 2>/dev/null | grep -q 'installed$'; then
    continue
  fi
  if apt-cache show "$package" >/dev/null 2>&1; then
    available+=("$package")
  else
    failed+=("apt:$package")
    printf 'UNAVAILABLE: apt package %s\n' "$package" >&2
  fi
done

if [ "${#available[@]}" -gt 0 ]; then
  run sudo apt-get install -y "${available[@]}"
fi

install_snap() {
  local package=$1
  shift
  if snap list "$package" >/dev/null 2>&1; then
    return 0
  fi
  if ! snap info "$package" >/dev/null 2>&1; then
    failed+=("snap:$package")
    printf 'UNAVAILABLE: snap %s\n' "$package" >&2
    return 0
  fi
  if ! run sudo snap install "$package" "$@"; then
    failed+=("snap:$package")
  fi
}

if [ "$profile" = devops ] || [ "$profile" = all ]; then
  install_snap kubectl --classic
  install_snap helm --classic
  install_snap k9s
  install_snap terraform --classic
fi
if [ "$profile" = desktop ] || [ "$profile" = all ]; then
  install_snap code --classic
  install_snap obsidian --classic
fi

if [ "${#failed[@]}" -gt 0 ]; then
  printf 'Completed with unavailable/failed items: %s\n' "${failed[*]}" >&2
  exit 1
fi
printf 'Completed profile: %s\n' "$profile"
