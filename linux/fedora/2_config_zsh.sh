#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"


echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSTALL-CONFIGURE ZSH"
#ZSH
#https://www.zsh.org
#https://github.com/zsh-users
sudo dnf install zsh -y
sudo dnf install zsh-completions -y

# Oh My Zsh
# https://ohmyz.sh/#install
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
if [ -d "$HOME/.oh-my-zsh/.git" ]; then
  git -C "$HOME/.oh-my-zsh" pull --ff-only
else
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

#zsh fonts
# for vscode
sudo cp "$SCRIPT_DIR/files/Menlo_for_Powerline.ttf" /usr/share/fonts/
sudo fc-cache -vf /usr/share/fonts/

# plugins
#https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/.git" ]; then
  git -C "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" pull --ff-only
else
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi
if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/.git" ]; then
  git -C "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" pull --ff-only
else
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
fi

# Configure zsh-autosuggestions (history + completion strategies)
ZA_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
mkdir -p "$ZA_DIR"
cat > "$ZA_DIR/local.config.zsh" <<'EOF'
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
cat > "$OMZ_CUSTOM_MAIN" <<'EOF'
# Load local tuning for zsh-autosuggestions
if [ -f "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/local.config.zsh" ]; then
  source "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/local.config.zsh"
fi
EOF

cp "$SCRIPT_DIR/files/.zshrc" "$HOME/.zshrc"
# chsh -s $(which zsh)
chsh -s "$(command -v zsh)" "$USER" || echo "Could not change shell automatically; run: chsh -s $(command -v zsh) $USER"
which "$SHELL" || true



# --- Oh My Zsh custom plugin for OpenTofu (plugin-based completion) ---
OMZ_CUSTOM_DIR="$HOME/.oh-my-zsh/custom/plugins/tofu"
mkdir -p "$OMZ_CUSTOM_DIR"
cat > "$OMZ_CUSTOM_DIR/tofu.plugin.zsh" <<'EOF'
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
