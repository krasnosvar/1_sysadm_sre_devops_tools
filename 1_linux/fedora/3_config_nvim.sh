#!/usr/bin/env bash
# Fedora Neovim + LazyVim setup script
#
# This script installs Neovim and a curated LazyVim configuration with popular plugins on Fedora.
# It is safe to re-run: existing configs are backed up, and installs are idempotent where possible.
#
# Reference article (for background): https://fedoramagazine.org/configuring-neovim-on-fedora-as-an-ide-and-using-lazyvim/

set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
# shellcheck source=lib_fedora_setup.sh
. "$SCRIPT_DIR/lib_fedora_setup.sh"

# --- Detect Fedora/dnf ---
require_fedora

# --- Install base dependencies ---
log "Installing Neovim and common developer tools via dnf..."
dnf_install_if_missing \
  neovim \
  git \
  curl \
  wget \
  ripgrep \
  fd-find \
  unzip \
  tar \
  make \
  gcc \
  nodejs \
  npm \
  python3 \
  python3-pip

# Optional: lazygit if available in repos
if dnf info lazygit >/dev/null 2>&1; then
  log "Installing lazygit..."
  dnf_install_if_missing lazygit || warn "Failed to install lazygit (optional)."
else
  warn "'lazygit' not found in repos; skipping (optional)."
fi

# Ensure python neovim support (some plugins/tools rely on it)
python3 -m pip install --user --upgrade pynvim >/dev/null 2>&1 || true

# --- Bootstrap LazyVim config without replacing an existing working config ---
NVIM_CONFIG_DIR="$HOME/.config/nvim"
backup_if_exists() {
  local p="$1"
  if [ -e "$p" ]; then
    local dest
    dest="${p}_backup_$(date +%Y%m%d_%H%M%S)"
    log "Backing up $p -> $dest"
    mv "$p" "$dest"
  fi
}

if [ -f "$NVIM_CONFIG_DIR/lazy-lock.json" ] || [ -d "$NVIM_CONFIG_DIR/lua" ]; then
  log "Existing Neovim config found; preserving it: $NVIM_CONFIG_DIR"
elif [ -e "$NVIM_CONFIG_DIR" ]; then
  backup_if_exists "$NVIM_CONFIG_DIR"
  log "Cloning LazyVim starter into $NVIM_CONFIG_DIR ..."
  git clone --depth=1 https://github.com/LazyVim/starter "$NVIM_CONFIG_DIR"
  rm -rf "$NVIM_CONFIG_DIR/.git"
else
  log "Cloning LazyVim starter into $NVIM_CONFIG_DIR ..."
  git clone --depth=1 https://github.com/LazyVim/starter "$NVIM_CONFIG_DIR"
  rm -rf "$NVIM_CONFIG_DIR/.git"
fi

# --- Add extra popular plugins via LazyVim spec ---
# We'll create a custom plugin spec at: ~/.config/nvim/lua/plugins/extras.lua
PLUGINS_DIR="$NVIM_CONFIG_DIR/lua/plugins"
mkdir -p "$PLUGINS_DIR"

write_file_if_changed "$PLUGINS_DIR/extras.lua" <<'EOF'
-- Extra popular plugins layered on top of LazyVim starter
-- Each entry adheres to lazy.nvim spec tables
return {
  -- Statusline
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "auto" } } },

  -- File explorer
  { "nvim-tree/nvim-tree.lua", cmd = { "NvimTreeToggle", "NvimTreeFindFile" }, opts = {} },

  -- Telescope fuzzy finder + fzf native
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
        config = function()
          pcall(function()
            require("telescope").load_extension("fzf")
          end)
        end,
      },
    },
  },

  -- Treesitter (ensure some common languages)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash", "lua", "vim", "vimdoc", "json", "yaml", "toml", "python",
        "go", "rust", "javascript", "typescript", "tsx", "html", "css",
      },
    },
  },

  -- Commenting
  { "numToStr/Comment.nvim", opts = {} },

  -- Git indicators
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- Buffer line
  { "akinsho/bufferline.nvim", event = "VeryLazy", opts = {} },

  -- Indent guides
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- Autopairs
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- Which-key (keybinding helper)
  { "folke/which-key.nvim", opts = {} },

  -- Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-macchiato")
    end,
  },
}
EOF

# --- Set default project directory on empty Neovim start ---
# Ensure the directory exists
mkdir -p "$HOME/my_projects"

# Append an autocmd to change cwd to ~/my_projects when launching nvim with no file args
AUTOCMDS_FILE="$NVIM_CONFIG_DIR/lua/config/autocmds.lua"
mkdir -p "$(dirname "$AUTOCMDS_FILE")"
if ! grep -q 'Auto change working directory to ~/my_projects on empty startup' "$AUTOCMDS_FILE" 2>/dev/null; then
cat >> "$AUTOCMDS_FILE" <<'EOF_ACMD'
-- Auto change working directory to ~/my_projects on empty startup
-- (only when launching nvim without file arguments)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      local dir = vim.fn.expand("~/my_projects")
      if vim.fn.isdirectory(dir) == 1 then
        vim.cmd("cd " .. vim.fn.fnameescape(dir))
      end
    end
  end,
})
EOF_ACMD
fi

# --- Initial plugin sync (headless) ---
require_cmd nvim
log "Syncing plugins headlessly (this may take a while on first run)..."
nvim --headless "+Lazy! sync" +qa || true

log "All done! Launch Neovim with: nvim"
log "Your config is in: $NVIM_CONFIG_DIR"
