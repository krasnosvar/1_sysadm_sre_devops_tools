#!/usr/bin/env bash
# ============================================================================
# AI Tools (Fedora)
# ============================================================================
# AI editors/IDEs, CLI agents, terminals and local LLM runners.
# Split out from 1_fedora-desktop-43-update.sh.
#
# Prerequisite: Node.js, NVM and npm are installed by
# 1_fedora-desktop-43-update.sh ("programming, development" section).
# Run that first, or install Node.js before using the npm/npx based tools below.
# See also the curated list: ../../what_to_learn/ai_tools_for_coding/README.md
# ============================================================================


# ============================================================================
# 1. AI IDEs / editors
# ============================================================================
# NOTE: 4_config_vscode.sh installs these same editors AND distributes
# settings.json + AI extensions + MCP config. Run that for the full setup;
# the commands below just install the AI editors standalone.

# Cursor - https://www.cursor.com/
sudo tee /etc/yum.repos.d/cursor.repo > /dev/null <<EOF
[cursor]
name=Cursor
baseurl=https://downloads.cursor.com/yumrepo
enabled=1
gpgcheck=1
gpgkey=https://downloads.cursor.com/keys/anysphere.asc
repo_gpgcheck=1
EOF

# Windsurf / Devin Desktop - https://devin.ai/ (formerly windsurf.com)
sudo rpm --import https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf || true
sudo tee /etc/yum.repos.d/windsurf.repo > /dev/null <<EOF
[windsurf]
name=Windsurf Repository
baseurl=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/repo/
enabled=1
autorefresh=1
gpgcheck=1
gpgkey=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf
EOF

# Google Antigravity - https://antigravity.google/
sudo tee /etc/yum.repos.d/antigravity.repo > /dev/null <<'EOF'
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOF

sudo dnf check-update || true
sudo dnf install -y cursor windsurf antigravity


# ============================================================================
# 2. AI CLI agents
# ============================================================================
# Note on Node.js / NPM:
# Node.js, NVM, and 'npm' are installed by 1_fedora-desktop-43-update.sh in the
# "programming, development" section. We use those tools here to run AI CLIs.

# opencode - open-source AI coding agent for the terminal
# https://opencode.ai/
# Option 1: official installer (installs to ~/.opencode/bin)
curl -fsSL https://opencode.ai/install | bash
# Option 2: via npm (Node/npm already installed above)
# npm install -g opencode-ai

# Claude Code - Anthropic's agentic coding CLI
# https://claude.com/product/claude-code
npm install -g @anthropic-ai/claude-code

# Codex - OpenAI's coding agent CLI
# https://openai.com/codex/
#   /init - create an AGENTS.md ; /status ; /approvals ; /model
npm install -g @openai/codex

# Google Gemini CLI
# https://github.com/google-gemini/gemini-cli
npm install -g @google/gemini-cli

# Tip: to run any of the above without installing globally, use npx, e.g.:
#   npx @anthropic-ai/claude-code
#   npx @openai/codex
#   npx @google/gemini-cli


# ============================================================================
# 3. Other AI tools (terminals, local LLM runners, self-hosted)
# ============================================================================

# warp terminal - AI-native terminal
# https://docs.warp.dev/getting-started/readme/installation-and-setup
sudo rpm --import https://releases.warp.dev/linux/keys/warp.asc
sudo sh -c 'echo -e "[warpdotdev]\nname=warpdotdev\nbaseurl=https://releases.warp.dev/linux/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://releases.warp.dev/linux/keys/warp.asc" > /etc/yum.repos.d/warpdotdev.repo'
sudo dnf install warp-terminal

# LM Studio - local LLM runner (desktop GUI + `lms` CLI)
# https://lmstudio.ai/
# CLI bootstrap (installs the `lms` command for headless/server use):
curl -fsSL https://lmstudio.ai/install.sh | bash
lms bootstrap
# GUI app: download the AppImage from https://lmstudio.ai/download , then
# install it into ~/Applications with a menu entry (icon extracted from the AppImage).
# AppImage needs FUSE: sudo dnf install -y fuse fuse-libs  (or run with --appimage-extract-and-run)
LMSTUDIO_APPIMAGE=$(ls -t "$HOME/Downloads"/LM-Studio-*.appimage "$HOME/Downloads"/LM-Studio-*.AppImage 2>/dev/null | head -1)
if [ -n "${LMSTUDIO_APPIMAGE}" ]; then
    APPDIR="$HOME/Applications"
    mkdir -p "$APPDIR"
    mv "${LMSTUDIO_APPIMAGE}" "$APPDIR/LM-Studio.appimage"
    chmod +x "$APPDIR/LM-Studio.appimage"
    # extract the official icon from the AppImage for the menu entry
    WORK=$(mktemp -d) && cd "$WORK"
    "$APPDIR/LM-Studio.appimage" --appimage-extract >/dev/null 2>&1 || true
    ICONSRC=$(find "$WORK/squashfs-root" -maxdepth 3 -iname '*.png' 2>/dev/null | sort | head -1)
    if [ -n "${ICONSRC}" ]; then cp "${ICONSRC}" "$APPDIR/lm-studio.png"; ICON="$APPDIR/lm-studio.png"; else ICON=application-x-executable; fi
    cd "$HOME" && /bin/rm -rf "$WORK"
    cat > ~/.local/share/applications/lm-studio.desktop <<EOF
[Desktop Entry]
Name=LM Studio
Comment=Run local LLMs (GUI)
Exec=$APPDIR/LM-Studio.appimage %U
Icon=$ICON
Type=Application
Categories=Development;Utility;
Terminal=false
EOF
    update-desktop-database ~/.local/share/applications 2>/dev/null || true
else
    echo "LM Studio AppImage not found in ~/Downloads; download it from https://lmstudio.ai/download"
fi

# Disable LM Studio's background "Local Service" so closing the window actually
# stops the LLM server (otherwise it lingers in the system tray on :PORT).
# settings.json is created by LM Studio on first run; we patch it if it exists,
# otherwise seed a minimal file (LM Studio merges its defaults on top).
# NOTE: must be done while LM Studio is NOT running, or it overwrites on exit.
LMS_SETTINGS="$HOME/.lmstudio/settings.json"
mkdir -p "$HOME/.lmstudio"
if [ -f "$LMS_SETTINGS" ]; then
    python3 - "$LMS_SETTINGS" <<'PY'
import json, sys
path = sys.argv[1]
with open(path) as f:
    cfg = json.load(f)
cfg["enableLocalService"] = False
with open(path, "w") as f:
    json.dump(cfg, f, indent=2)
PY
else
    printf '{\n  "enableLocalService": false\n}\n' > "$LMS_SETTINGS"
fi

# OpenAgent - self-hosted single-binary AI assistant (web dashboard on :14000)
# https://www.openagentai.org/
# It has NO native desktop app: the binary runs a local web server and serves a
# dashboard at http://localhost:14000 . Installs to ~/.local/share/openagent .
curl -fsSL https://raw.githubusercontent.com/the-open-agent/openagent/master/scripts/install.sh | bash
# then open http://localhost:14000
#
# Make it feel like a desktop app: a launcher that starts the server (if needed)
# and opens the dashboard in a standalone app-mode Chromium window (no tabs/URL bar).
OA_DIR="$HOME/.local/share/openagent"
if [ -x "$OA_DIR/openagent" ]; then
    cat > "$OA_DIR/openagent-app.sh" <<'EOS'
#!/usr/bin/env bash
# Launch OpenAgent as a desktop app: ensure the server is up, open the dashboard
# in a standalone (app-mode) Chromium window, and stop the server when the
# window is closed (only if this launcher started it).
BIN="$HOME/.local/share/openagent/openagent"
URL="http://localhost:14000"
PROFILE="$HOME/.local/share/openagent/browser-profile"

SERVER_PID=""
if ! curl -fsS --max-time 1 "$URL" >/dev/null 2>&1; then
    setsid "$BIN" serve >/dev/null 2>&1 &
    SERVER_PID=$!
    for _ in $(seq 1 40); do
        curl -fsS --max-time 1 "$URL" >/dev/null 2>&1 && break
        sleep 0.5
    done
fi

# When the app window closes, stop the server we started (kill the process group).
cleanup() {
    [ -n "$SERVER_PID" ] && kill -- -"$SERVER_PID" 2>/dev/null
}
trap cleanup EXIT INT TERM

BROWSER=""
for b in chromium chromium-browser google-chrome-stable google-chrome brave-browser vivaldi-stable; do
    command -v "$b" >/dev/null 2>&1 && { BROWSER="$b"; break; }
done

if [ -n "$BROWSER" ]; then
    # Dedicated --user-data-dir makes this its own browser process, so the
    # command stays in the foreground until the window is closed.
    "$BROWSER" --app="$URL" --user-data-dir="$PROFILE" --class=OpenAgent --name=OpenAgent >/dev/null 2>&1
else
    xdg-open "$URL"  # no Chromium browser: open default (can't track close)
fi
EOS
    chmod +x "$OA_DIR/openagent-app.sh"
    # Grab the official logo for the menu icon (fallback to a generic icon).
    OA_ICON=application-x-executable
    if curl -fsSL --max-time 10 -o "$OA_DIR/openagent.png" https://cdn.openagentai.org/img/openagent.png 2>/dev/null && [ -s "$OA_DIR/openagent.png" ]; then
        OA_ICON="$OA_DIR/openagent.png"
    fi
    cat > ~/.local/share/applications/openagent.desktop <<EOF
[Desktop Entry]
Name=OpenAgent
Comment=Self-hosted AI assistant (local dashboard on :14000)
Exec=$OA_DIR/openagent-app.sh
Icon=$OA_ICON
Type=Application
Categories=Development;Utility;
Terminal=false
StartupWMClass=OpenAgent
EOF
    update-desktop-database ~/.local/share/applications 2>/dev/null || true
fi
