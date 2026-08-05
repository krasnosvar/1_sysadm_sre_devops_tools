#!/usr/bin/env bash
set -euo pipefail

# AI Tools (Fedora)
# AI editors/IDEs, CLI agents, terminals and local LLM runners.
# Safe to re-run: checks installed tools, refreshes repo files, and installs
# missing packages without relying on root-owned npm global directories.

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
# shellcheck source=lib_fedora_setup.sh
. "$SCRIPT_DIR/lib_fedora_setup.sh"

require_fedora

log "Installing base dependencies"
dnf_install_if_missing curl ca-certificates gnupg jq nodejs npm pipx

log "Configuring AI editor repositories"
sudo_write_file_if_changed /etc/yum.repos.d/cursor.repo <<'EOF'
[cursor]
name=Cursor
baseurl=https://downloads.cursor.com/yumrepo
enabled=1
gpgcheck=1
gpgkey=https://downloads.cursor.com/keys/anysphere.asc
repo_gpgcheck=1
EOF

sudo rpm --import https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf || true
sudo_write_file_if_changed /etc/yum.repos.d/windsurf.repo <<'EOF'
[windsurf]
name=Windsurf Repository
baseurl=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/repo/
enabled=1
autorefresh=1
gpgcheck=1
gpgkey=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf
EOF

sudo_write_file_if_changed /etc/yum.repos.d/antigravity.repo <<'EOF'
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOF

log "Installing AI IDEs"
sudo dnf check-update || true
dnf_install_if_missing cursor windsurf antigravity

log "Configuring npm global installs for the current user"
ensure_npm_user_prefix "$HOME/.local"
append_line_if_missing "$HOME/.zshrc" 'export PATH="$HOME/.local/bin:$PATH"'

log "Installing or updating AI CLI agents"
npm_global_install_or_update @anthropic-ai/claude-code claude
npm_global_install_or_update @openai/codex codex
npm_global_install_or_update @google/gemini-cli gemini
npm_global_install_or_update @qwen-code/qwen-code qwen
npm_global_install_or_update @charmland/crush crush

pipx ensurepath || true
pipx_install_or_upgrade aider-chat aider

if command -v opencode >/dev/null 2>&1; then
  log "opencode already installed: $(command -v opencode)"
else
  log "Installing opencode"
  curl -fsSL https://opencode.ai/install | bash
fi
append_line_if_missing "$HOME/.zshrc" 'export PATH="$HOME/.opencode/bin:$PATH"'

if command -v goose >/dev/null 2>&1; then
  log "Updating goose CLI"
  goose update || true
else
  log "Installing goose CLI"
  curl -fsSL https://github.com/aaif-goose/goose/releases/download/stable/download_cli.sh | CONFIGURE=false bash
fi

log "Installing Warp terminal"
sudo rpm --import https://releases.warp.dev/linux/keys/warp.asc || true
sudo_write_file_if_changed /etc/yum.repos.d/warpdotdev.repo <<'EOF'
[warpdotdev]
name=warpdotdev
baseurl=https://releases.warp.dev/linux/rpm/stable
enabled=1
gpgcheck=1
gpgkey=https://releases.warp.dev/linux/keys/warp.asc
EOF
dnf_install_if_missing warp-terminal

log "Installing LM Studio CLI"
if command -v lms >/dev/null 2>&1; then
  log "lms already installed: $(command -v lms)"
else
  curl -fsSL https://lmstudio.ai/install.sh | bash
fi
if command -v lms >/dev/null 2>&1; then
  lms bootstrap || true
else
  warn "lms command is still unavailable after installer"
fi

log "Configuring LM Studio desktop entry if AppImage exists"
LMSTUDIO_APPIMAGE="$(find "$HOME/Downloads" -maxdepth 1 -type f \( -iname 'LM-Studio-*.appimage' -o -iname 'LM-Studio-*.AppImage' \) 2>/dev/null | sort -r | head -1 || true)"
if [ -n "$LMSTUDIO_APPIMAGE" ]; then
  APPDIR="$HOME/Applications"
  mkdir -p "$APPDIR" "$HOME/.local/share/applications"
  install -m 0755 "$LMSTUDIO_APPIMAGE" "$APPDIR/LM-Studio.appimage"

  ICON="application-x-executable"
  WORK="$(mktemp -d)"
  if (cd "$WORK" && "$APPDIR/LM-Studio.appimage" --appimage-extract >/dev/null 2>&1); then
    ICONSRC="$(find "$WORK/squashfs-root" -maxdepth 3 -iname '*.png' 2>/dev/null | sort | head -1 || true)"
    if [ -n "$ICONSRC" ]; then
      install -m 0644 "$ICONSRC" "$APPDIR/lm-studio.png"
      ICON="$APPDIR/lm-studio.png"
    fi
  fi
  rm -rf "$WORK"

  write_file_if_changed "$HOME/.local/share/applications/lm-studio.desktop" <<EOF
[Desktop Entry]
Name=LM Studio
Comment=Run local LLMs (GUI)
Exec=$APPDIR/LM-Studio.appimage %U
Icon=$ICON
Type=Application
Categories=Development;Utility;
Terminal=false
EOF
  update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
else
  warn "LM Studio AppImage not found in ~/Downloads; GUI installer skipped"
fi

log "Disabling LM Studio background local service"
LMS_SETTINGS="$HOME/.lmstudio/settings.json"
mkdir -p "$HOME/.lmstudio"
if [ -f "$LMS_SETTINGS" ] && python3 - "$LMS_SETTINGS" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    cfg = json.load(f)
cfg["enableLocalService"] = False
with open(path, "w", encoding="utf-8") as f:
    json.dump(cfg, f, indent=2)
    f.write("\n")
PY
then
  log "Updated: $LMS_SETTINGS"
else
  write_file_if_changed "$LMS_SETTINGS" <<'EOF'
{
  "enableLocalService": false
}
EOF
fi

log "Removing OpenAgent launcher from the old setup"
rm -f "$HOME/.local/share/applications/openagent.desktop" "$HOME/.local/share/openagent/openagent-app.sh"

log "Installing AnythingLLM Desktop"
ANYTHINGLLM_DIR="$HOME/Applications"
ANYTHINGLLM_APPIMAGE="$ANYTHINGLLM_DIR/AnythingLLM.AppImage"
ANYTHINGLLM_API="https://api.github.com/repos/Mintplex-Labs/anything-llm/releases/latest"
ANYTHINGLLM_URL="$(curl -fsSL "$ANYTHINGLLM_API" | jq -r 'first([.assets[] | select(.name | test("(?i)appimage$")) | .browser_download_url]) // empty')"
if [ -n "$ANYTHINGLLM_URL" ] && [ "$ANYTHINGLLM_URL" != "null" ]; then
  mkdir -p "$ANYTHINGLLM_DIR" "$HOME/.local/share/applications"
  TMP_APPIMAGE="$(mktemp)"
  curl -fL "$ANYTHINGLLM_URL" -o "$TMP_APPIMAGE"
  install -m 0755 "$TMP_APPIMAGE" "$ANYTHINGLLM_APPIMAGE"
  rm -f "$TMP_APPIMAGE"

  ANYTHINGLLM_ICON="application-x-executable"
  WORK="$(mktemp -d)"
  if (cd "$WORK" && "$ANYTHINGLLM_APPIMAGE" --appimage-extract >/dev/null 2>&1); then
    ICONSRC="$(find "$WORK/squashfs-root" -maxdepth 4 -iname '*.png' 2>/dev/null | sort | head -1 || true)"
    if [ -n "$ICONSRC" ]; then
      install -m 0644 "$ICONSRC" "$ANYTHINGLLM_DIR/anythingllm.png"
      ANYTHINGLLM_ICON="$ANYTHINGLLM_DIR/anythingllm.png"
    fi
  fi
  rm -rf "$WORK"

  write_file_if_changed "$HOME/.local/share/applications/anythingllm.desktop" <<EOF
[Desktop Entry]
Name=AnythingLLM
Comment=Local-first AI desktop app
Exec=$ANYTHINGLLM_APPIMAGE %U
Icon=$ANYTHINGLLM_ICON
Type=Application
Categories=Development;Utility;
Terminal=false
StartupWMClass=AnythingLLM
EOF
  update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
else
  warn "Could not find AnythingLLM Linux AppImage in latest GitHub release"
fi

log "AI tools setup complete"
log "Codex CLI: $(command -v codex 2>/dev/null || printf 'not found')"
codex --version 2>/dev/null || true
