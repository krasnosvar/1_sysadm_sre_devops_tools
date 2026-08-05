#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
# shellcheck source=lib_fedora_setup.sh
. "$SCRIPT_DIR/lib_fedora_setup.sh"


echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSTALL-CONFIGURE ZSH"
#ZSH
#https://www.zsh.org
#https://github.com/zsh-users
dnf_install_if_missing zsh zsh-completions

# Oh My Zsh
# https://ohmyz.sh/#install
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git_clone_or_update https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"

#zsh fonts
# for vscode
if ! sudo test -f /usr/share/fonts/Menlo_for_Powerline.ttf || ! sudo cmp -s "$SCRIPT_DIR/files/Menlo_for_Powerline.ttf" /usr/share/fonts/Menlo_for_Powerline.ttf; then
  sudo install -m 0644 "$SCRIPT_DIR/files/Menlo_for_Powerline.ttf" /usr/share/fonts/Menlo_for_Powerline.ttf
  sudo fc-cache -vf /usr/share/fonts/
else
  log "Font already installed: Menlo_for_Powerline.ttf"
fi

# plugins
#https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
git_clone_or_update https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
git_clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

# Configure zsh-autosuggestions (history + completion strategies)
ZA_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
mkdir -p "$ZA_DIR"
write_file_if_changed "$ZA_DIR/local.config.zsh" <<'EOF'
# Local tuning for zsh-autosuggestions
# Use history first, then completion as a fallback for richer suggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Async for responsiveness; limit buffer size
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=200000

# Subtle suggestion color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Optional: accept suggestion with Ctrl-Space
bindkey '^ ' autosuggest-accept
EOF

# Ensure OMZ loads the autosuggestions config (custom files are sourced automatically)
OMZ_CUSTOM_MAIN="$HOME/.oh-my-zsh/custom/10-zsh-autosuggestions-config.zsh"
write_file_if_changed "$OMZ_CUSTOM_MAIN" <<'EOF'
# Load local tuning for zsh-autosuggestions
if [ -f "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/local.config.zsh" ]; then
  source "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/local.config.zsh"
fi
EOF

if [ ! -f "$HOME/.zshrc" ] || cmp -s "$HOME/.zshrc" "$SCRIPT_DIR/files/.zshrc"; then
  install -m 0644 "$SCRIPT_DIR/files/.zshrc" "$HOME/.zshrc"
  log "Installed zshrc template: $HOME/.zshrc"
else
  warn "$HOME/.zshrc already exists and differs from template; preserving user file"
fi
# chsh -s $(which zsh)
chsh -s "$(command -v zsh)" "$USER" || echo "Could not change shell automatically; run: chsh -s $(command -v zsh) $USER"
which "$SHELL" || true



# --- Oh My Zsh custom plugin for OpenTofu (plugin-based completion) ---
OMZ_CUSTOM_DIR="$HOME/.oh-my-zsh/custom/plugins/tofu"
mkdir -p "$OMZ_CUSTOM_DIR"
write_file_if_changed "$OMZ_CUSTOM_DIR/tofu.plugin.zsh" <<'EOF'
# OpenTofu completion via custom Oh My Zsh plugin
if command -v tofu >/dev/null 2>&1; then
  if tofu completion zsh >/dev/null 2>&1; then
    source <(tofu completion zsh)
  fi
fi
EOF

# Ensure 'tofu' appears in plugins=(...) list
if ! grep -qE '^plugins=.*\btofu\b' "$HOME/.zshrc" 2>/dev/null; then
  # Insert tofu before trailing highlighting plugins if present; else append
  if grep -qE '^plugins=.*zsh-syntax-highlighting.*zsh-autosuggestions.*\)' "$HOME/.zshrc"; then
    sed -i 's/^plugins=(\(.*\) zsh-syntax-highlighting zsh-autosuggestions)/plugins=(\1 tofu zsh-syntax-highlighting zsh-autosuggestions)/' "$HOME/.zshrc"
  else
    sed -i 's/^plugins=(\(.*\))/plugins=(\1 tofu)/' "$HOME/.zshrc"
  fi
fi

echo "Oh My Zsh custom plugin for OpenTofu installed (plugins+=tofu)"
