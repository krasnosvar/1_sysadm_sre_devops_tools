#!/usr/bin/env bash

# Shared helpers for Fedora workstation setup scripts.
# Source this file after `set -euo pipefail`.

log() { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
die() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

require_fedora() {
  command -v dnf >/dev/null 2>&1 || die "dnf not found. This script is intended for Fedora."
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

# Download the complete installer before execution. This avoids executing a
# truncated response and leaves one auditable trust boundary: the documented
# upstream HTTPS URL. Prefer a signed RPM repository whenever one is available.
run_https_bash_installer() {
  local as_root=0
  local url
  local installer
  local status=0

  if [ "${1:-}" = "--sudo" ]; then
    as_root=1
    shift
  fi
  url="$1"
  shift
  installer="$(mktemp)"
  if ! curl --proto '=https' --tlsv1.2 -fsSL "$url" -o "$installer"; then
    rm -f "$installer"
    die "Failed to download installer: $url"
  fi
  chmod 0700 "$installer"
  if [ "$as_root" -eq 1 ]; then
    sudo /bin/bash "$installer" "$@" || status=$?
  else
    /bin/bash "$installer" "$@" || status=$?
  fi
  rm -f "$installer"
  return "$status"
}

dnf_install() {
  require_fedora
  sudo dnf install -y "$@"
}

dnf_install_if_missing() {
  local missing=()
  local pkg

  require_fedora
  for pkg in "$@"; do
    if ! rpm -q "$pkg" >/dev/null 2>&1; then
      missing+=("$pkg")
    fi
  done

  if [ "${#missing[@]}" -gt 0 ]; then
    log "Installing RPM packages: ${missing[*]}"
    sudo dnf install -y "${missing[@]}"
  else
    log "RPM packages already installed: $*"
  fi
}

flatpak_user_install_if_missing() {
  local remote="$1"
  shift
  local app

  require_cmd flatpak
  for app in "$@"; do
    if flatpak info --user "$app" >/dev/null 2>&1; then
      log "Flatpak already installed: $app"
    else
      log "Installing Flatpak: $app"
      flatpak install --user -y "$remote" "$app"
    fi
  done
}

write_file_if_changed() {
  local target="$1"
  local tmp
  tmp="$(mktemp)"
  cat > "$tmp"

  if [ -f "$target" ] && cmp -s "$tmp" "$target"; then
    rm -f "$tmp"
    log "Unchanged: $target"
    return 0
  fi

  mkdir -p "$(dirname "$target")"
  install -m 0644 "$tmp" "$target"
  rm -f "$tmp"
  log "Written: $target"
}

sudo_write_file_if_changed() {
  local target="$1"
  local tmp
  tmp="$(mktemp)"
  cat > "$tmp"

  if sudo test -f "$target" && sudo cmp -s "$tmp" "$target"; then
    rm -f "$tmp"
    log "Unchanged: $target"
    return 0
  fi

  sudo install -D -m 0644 "$tmp" "$target"
  rm -f "$tmp"
  log "Written: $target"
}

append_line_if_missing() {
  local file="$1"
  local line="$2"

  mkdir -p "$(dirname "$file")"
  touch "$file"
  if grep -qxF "$line" "$file"; then
    log "Line already present in $file: $line"
  else
    printf '%s\n' "$line" >> "$file"
    log "Appended to $file: $line"
  fi
}

git_clone_or_update() {
  local repo="$1"
  local dest="$2"

  if [ -d "$dest/.git" ]; then
    log "Updating git repo: $dest"
    git -C "$dest" pull --ff-only
  elif [ -e "$dest" ]; then
    warn "Path exists and is not a git repo, skipping clone: $dest"
  else
    log "Cloning $repo -> $dest"
    git clone "$repo" "$dest"
  fi
}

ensure_npm_user_prefix() {
  local prefix="${1:-$HOME/.local}"

  mkdir -p "$prefix/bin" "$prefix/lib"
  if [ "$(npm config get prefix 2>/dev/null || true)" != "$prefix" ]; then
    npm config set prefix "$prefix"
  fi
  case ":$PATH:" in
    *":$prefix/bin:"*) ;;
    *) export PATH="$prefix/bin:$PATH" ;;
  esac
}

npm_global_install_or_update() {
  local package="$1"
  local binary="${2:-}"

  require_cmd npm
  ensure_npm_user_prefix "$HOME/.local"

  if [ -n "$binary" ] && command -v "$binary" >/dev/null 2>&1; then
    log "Updating npm global package: $package"
  else
    log "Installing npm global package: $package"
  fi
  npm install -g "$package"
}

pipx_install_or_upgrade() {
  local package="$1"
  local binary="${2:-}"

  require_cmd pipx
  # Keep HOME and PATH literal: this line is evaluated by future shells.
  # shellcheck disable=SC2016
  append_line_if_missing "$HOME/.zshrc" 'export PATH="$HOME/.local/bin:$PATH"'

  if [ -n "$binary" ] && command -v "$binary" >/dev/null 2>&1; then
    log "Upgrading pipx package: $package"
    pipx upgrade "$package" || pipx install "$package"
  else
    log "Installing pipx package: $package"
    pipx install "$package"
  fi
}
