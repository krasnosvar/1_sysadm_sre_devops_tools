#!/usr/bin/env bash
# VS Code & AI IDE forks installation and configuration script
# Installs and configures: VSCode, VSCodium, Cursor, Windsurf, Antigravity
# Creates:
#   1. Global AGENTS.md file with agent guidance
#   2. mcp.json for MCP (Model Context Protocol) integration

set -euo pipefail

log() { printf '%s\n' "$*"; }

log "======================================================================"
log "1. Installing VS Code & Forks"
log "======================================================================"

log "-> Setting up VS Code repo..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc || true
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

log "-> Setting up VSCodium repo..."
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg || true
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee /etc/yum.repos.d/vscodium.repo > /dev/null

log "-> Setting up Cursor repo..."
sudo tee /etc/yum.repos.d/cursor.repo > /dev/null <<EOF
[cursor]
name=Cursor
baseurl=https://downloads.cursor.com/yumrepo
enabled=1
gpgcheck=1
gpgkey=https://downloads.cursor.com/keys/anysphere.asc
repo_gpgcheck=1
EOF

log "-> Setting up Windsurf repo..."
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

log "-> Setting up Antigravity repo..."
sudo tee /etc/yum.repos.d/antigravity.repo > /dev/null <<'EOF'
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOF

log "-> Installing IDEs..."
sudo dnf check-update || true
sudo dnf install -y code codium cursor windsurf antigravity

log "======================================================================"
log "2. Distributing settings.json"
log "======================================================================"

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
SETTINGS_FILE="${SCRIPT_DIR}/files/vscode/settings.json"

if [ -f "$SETTINGS_FILE" ]; then
  for editor_dir in Code VSCodium Cursor Antigravity Windsurf .codeium/windsurf; do
    if [ "$editor_dir" = ".codeium/windsurf" ]; then
      mkdir -p "$HOME/$editor_dir/User/"
      cp "$SETTINGS_FILE" "$HOME/$editor_dir/User/settings.json"
    else
      mkdir -p "$HOME/.config/$editor_dir/User/"
      cp "$SETTINGS_FILE" "$HOME/.config/$editor_dir/User/settings.json"
    fi
  done
  log "settings.json successfully distributed out to all IDEs."
else
  log "WARNING: $SETTINGS_FILE not found, skipping settings distribution."
fi

log "======================================================================"
log "3. Installing Extensions"
log "======================================================================"

for ideEditor in code codium cursor windsurf antigravity; do
  if command -v $ideEditor &> /dev/null; then
    log "-> Installing extensions via $ideEditor..."

    # --- Languages ---
    $ideEditor --install-extension ms-python.python --force || true  # Python: linting, debugging, IntelliSense
    $ideEditor --install-extension golang.Go --force || true  # Go: полная поддержка (gopls, delve, тесты)
    $ideEditor --install-extension redhat.java --force || true  # Java: Language Server от Red Hat
    $ideEditor --install-extension mathiasfrohlich.kotlin --force || true  # Kotlin: подсветка синтаксиса и базовая поддержка

    # --- Infrastructure & DevOps ---
    $ideEditor --install-extension redhat.vscode-yaml --force || true  # YAML: валидация, автодополнение, JSON Schema
    $ideEditor --install-extension ms-azuretools.vscode-docker --force || true  # Docker: управление контейнерами и образами
    $ideEditor --install-extension ms-kubernetes-tools.vscode-kubernetes-tools --force || true  # Kubernetes: работа с кластерами прямо из редактора
    $ideEditor --install-extension hashicorp.terraform --force || true  # Terraform: синтаксис HCL, автодополнение, валидация
    $ideEditor --install-extension ms-vscode-remote.remote-containers --force || true  # Dev Containers: разработка внутри Docker-контейнера

    # --- Git & Version Control ---
    $ideEditor --install-extension eamodio.gitlens --force || true  # GitLens: blame, история, сравнение веток
    $ideEditor --install-extension gitlab.gitlab-workflow --force || true  # GitLab: MR, пайплайны и CI/CD прямо в редакторе

    # --- Database ---
    $ideEditor --install-extension mtxr.sqltools --force || true  # SQLTools: универсальный клиент для SQL-баз данных

    # --- Docs & Markdown ---
    $ideEditor --install-extension davidanson.vscode-markdownlint --force || true  # markdownlint: линтер для .md файлов
    $ideEditor --install-extension domdomegg.markdown-inline-preview-vscode --force || true  # Markdown Inline Preview: превью прямо в строке
    $ideEditor --install-extension tomoki1207.pdf --force || true  # PDF Viewer: открытие PDF без выхода из редактора

    # --- AI Assistants ---
    $ideEditor --install-extension Codeium.codeium --force || true  # Codeium: бесплатный AI-ассистент (автодополнение, чат)
    $ideEditor --install-extension github.copilot-chat --force || true  # GitHub Copilot Chat: AI-чат и inline-подсказки от GitHub

    # --- Productivity ---
    $ideEditor --install-extension usernamehw.errorlens --force  # Error Lens: ошибки и предупреждения прямо в строке кода
    $ideEditor --install-extension t-p-f.go-group-imports --force  # Go Group Imports: группировка импортов (stdlib / external / internal)
    $ideEditor --install-extension Gruntfuggly.todo-tree --force  # Todo Tree: панель со всеми TODO и FIXME по проекту
    $ideEditor --install-extension alefragnani.Bookmarks --force  # Bookmarks: закладки для быстрой навигации по коду
    $ideEditor --install-extension humao.rest-client --force  # REST Client: HTTP-запросы через .http файлы (замена Postman)
    $ideEditor --install-extension esbenp.prettier-vscode --force  # Prettier: автоформатирование JSON, YAML, Markdown
  fi
done

log "======================================================================"
log "4. Special Cursor/MCP Rules setup"
log "======================================================================"

CURSOR_CONFIG_DIR="${HOME}/.config/cursor"
AGENTS_FILE="${HOME}/AGENTS.md"
MCP_FILE="${CURSOR_CONFIG_DIR}/mcp.json"
BACKUP_SUFFIX="backup_$(date +%Y%m%d_%H%M%S)"

backup_if_exists() {
  local p="$1"
  if [ -e "$p" ]; then
    local dest="${p}_${BACKUP_SUFFIX}"
    log "Backing up $p -> $dest"
    mv "$p" "$dest"
  fi
}

# Create Cursor config directory if needed
mkdir -p "${CURSOR_CONFIG_DIR}"

# --- 1. Create AGENTS.md file ---
log "Creating agent rules file: ${AGENTS_FILE}"
backup_if_exists "${AGENTS_FILE}"

cat > "${AGENTS_FILE}" << 'EOF'
# AI Agent General Rules
# Strict minimal-edit discipline & professional coding standards

## 1. Core Principles
- Use asserted inputs exactly as provided; never normalize, auto-correct, or invent defaults.
- Reject missing prerequisites immediately with explicit errors.
- Limit edits to in-scope targets; preserve existing style, design, and behavior elsewhere.
- Address only the requested scenario; skip speculative implementations or "just in case" branches.
- Fail fast in both logic and process—propagate clear, actionable errors at the first sign of invalid state.

## 2. Golang Development Standards
- **Error Handling:** Never swallow errors. Always check `if err != nil` and return explicitly. Use `fmt.Errorf("...: %w", err)` to wrap errors for context.
- **Panics:** Avoid `panic()` in production code. Use proper error returns instead.
- **Concurrency:** Avoid goroutine leaks. Always pass `context.Context` as the first argument in async/blocking functions. Ensure proper `sync.WaitGroup` or `errgroup` usage.
- **Testing:** Generate table-driven tests (`[]struct{ name string... }`) for all new logic. 
- **Formatting:** Code must be formatted using `gofumpt` and conform to `golangci-lint` standards.
- **Pointers:** Be careful with pointer vs value semantics. Avoid returning pointers to loop variables (in older Go versions).

## 3. Kubernetes & DevOps
- **Immutability:** Treat infrastructure as immutable. Avoid direct manual hacks; use IaC (Terraform/Ansible) configurations instead.
- **Terraform/Terragrunt:** Always format using `terraform fmt` or `terragrunt hclfmt`. Avoid hardcoding secrets; prefer SOPS or Vault.
- **Kubernetes Resources:** Always define resource `requests` and `limits` for CPU/Memory in Pod definitions. Use explicit `readinessProbe` and `livenessProbe`. Limit the use of `latest` tags.
- **Helm:** Write modular Helm charts. Ensure proper quoting in templates `{{ .Values.val | quote }}` to avoid YAML injection issues.

## 4. Troubleshooting
- Revert experimental changes after diagnosis is complete.
- Apply a single, clean fix once the root cause is identified. Document the "WHY" in commit logs.
- Rely on explicit logs, strace, and metrics tracking over guessing behavior.
EOF

chmod 644 "${AGENTS_FILE}"

if [ -f "${AGENTS_FILE}" ]; then
  log "Created: ${AGENTS_FILE}"
else
  log "Failed to create ${AGENTS_FILE}"
  exit 1
fi

# --- 2. Create mcp.json for MCP ---
log "Creating Context7 MCP configuration: ${MCP_FILE}"
backup_if_exists "${MCP_FILE}"

cat > "${MCP_FILE}" << 'EOF'
{
  "mcpServers": {
    "context7": {
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "YOUR_API_KEY"
      }
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<YOUR_GITHUB_TOKEN>"
      }
    },
    "kubernetes": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-kubernetes"]
    }
  }
}
EOF

chmod 644 "${MCP_FILE}"

if [ -f "${MCP_FILE}" ]; then
  log "Created: ${MCP_FILE}"
else
  log "Failed to create ${MCP_FILE}"
  exit 1
fi

# --- Final instructions ---
log ""
log "Configuration complete!"
log ""
log "Files created:"
log "  1. ${AGENTS_FILE}"
log "  2. ${MCP_FILE}"
log ""
log "IMPORTANT: Configure your MCP credentials in ${MCP_FILE}:"
log "  1. Context7: requires CONTEXT7_API_KEY"
log "  2. Github: requires GITHUB_PERSONAL_ACCESS_TOKEN"
log ""
log "Restart your IDE (Cursor/Windsurf) to apply these new MCP tools and AI instructions."
log "Reference: https://github.com/upstash/context7"
