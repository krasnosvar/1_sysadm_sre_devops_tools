#!/usr/bin/env bash
# Cursor IDE configuration script
# Creates:
#   1. global AGENTS.md file with agent guidance
#   2. mcp.json for MCP (Model Context Protocol) integration

set -euo pipefail

log() { printf '%s\n' "$*"; }

CURSOR_CONFIG_DIR="${HOME}/.config/cursor"
AGENTS_FILE="${HOME}/AGENTS.md"
MCP_FILE="${CURSOR_CONFIG_DIR}/mcp.json"
BACKUP_SUFFIX="backup_$(date +%Y%m%d_%H%M%S)"

backup_if_exists() {
  local p="$1"
  if [ -e "$p" ]; then
    local dest="${p}_${BACKUP_SUFFIX}"
    info "Backing up $p -> $dest"
    mv "$p" "$dest"
  fi
}

# Create Cursor config directory if needed
mkdir -p "${CURSOR_CONFIG_DIR}"

# --- 1. Create AGENTS.md file ---
log "Creating agent rules file: ${AGENTS_FILE}"
backup_if_exists "${AGENTS_FILE}"

cat > "${AGENTS_FILE}" << 'EOF'
# Cursor Agent Rules
# Strict minimal-edit discipline for agent mode

## Core Principles

- Use asserted inputs exactly as provided; never normalize, auto-correct, or invent defaults.
- Reject missing prerequisites immediately with explicit errors; avoid implicit fallbacks or silent success.
- Limit edits to in-scope targets; preserve existing style, design, and behavior elsewhere.
- During troubleshooting, back out failed trial changes once the root cause is known, then apply a single clean fix.
- Address only the requested scenario; skip speculative implementations or "just in case" branches.
- Follow the established minimal patterns already in the codebase; add no enhancements unless explicitly asked.
- Rely on concrete facts; if something is unclear, ask instead of guessing.
- Fail fast in both logic and process—propagate clear, actionable errors at the first sign of invalid state.
- When the task has a single input and a single desired outcome, deliver the smallest precise edit with no extra abstraction or future-proofing.

## Implementation Guidelines

### Input Handling
- Accept inputs verbatim without transformation
- Validate prerequisites before execution
- Error immediately on missing or invalid inputs

### Code Changes
- Make minimal, targeted edits only
- Preserve existing code style and patterns
- No refactoring unless explicitly requested
- No "improvements" beyond the stated requirement

### Error Handling
- Fail fast with clear, actionable error messages
- No silent fallbacks or default assumptions
- Propagate errors explicitly

### Scope Management
- Address only the specific request
- No speculative features or edge cases
- No future-proofing or over-engineering

### Troubleshooting
- Revert experimental changes after diagnosis
- Apply single, clean fix once root cause is identified
- Document the specific issue and resolution

## Anti-Patterns to Avoid

- Auto-correcting user input
- Adding "helpful" features not requested
- Abstracting for hypothetical future use
- Normalizing data without explicit instruction
- Implementing fallback logic without approval
- Making assumptions instead of asking
- Preserving broken trial code in the final solution
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
log "IMPORTANT: Configure Context7 MCP credentials:"
log "  1. Get Redis credentials from: https://console.upstash.com/"
log "  2. Edit ${MCP_FILE}"
log "  3. Set UPSTASH_REDIS_REST_URL and UPSTASH_REDIS_REST_TOKEN"
log ""
log "Restart Cursor IDE to apply changes."
log "Reference: https://github.com/upstash/context7"
