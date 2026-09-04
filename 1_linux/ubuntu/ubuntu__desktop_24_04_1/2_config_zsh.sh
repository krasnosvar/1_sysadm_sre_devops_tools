#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
omz="$HOME/.oh-my-zsh"
custom="${ZSH_CUSTOM:-$omz/custom}"

sudo apt-get install -y zsh fonts-powerline git

clone_or_update() {
  local repo=$1 destination=$2
  if [ -d "$destination/.git" ]; then
    git -C "$destination" pull --ff-only
  elif [ -e "$destination" ]; then
    printf 'skip existing non-git path: %s\n' "$destination" >&2
  else
    git clone --depth 1 "$repo" "$destination"
  fi
}

clone_or_update https://github.com/ohmyzsh/ohmyzsh.git "$omz"
clone_or_update https://github.com/zsh-users/zsh-autosuggestions.git \
  "$custom/plugins/zsh-autosuggestions"
clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "$custom/plugins/zsh-syntax-highlighting"

mkdir -p "$HOME/.config/sre-tools"
install -m 0644 "$script_dir/files/.zshrc" "$HOME/.config/sre-tools/zshrc"
touch "$HOME/.zshrc"
# Keep HOME literal: the installed shell evaluates it on startup.
# shellcheck disable=SC2016
line='source "$HOME/.config/sre-tools/zshrc"'
grep -qxF "$line" "$HOME/.zshrc" || printf '%s\n' "$line" >> "$HOME/.zshrc"

if command -v gsettings >/dev/null 2>&1; then
  gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 13'
fi

zsh_path="$(command -v zsh)"
if [ "${SHELL:-}" != "$zsh_path" ]; then
  chsh -s "$zsh_path"
fi
