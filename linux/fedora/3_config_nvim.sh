#!/usr/bin/env bash
# Fedora Neovim + LazyVim setup script
#
# This script installs Neovim and a curated LazyVim configuration with popular plugins on Fedora.
# It is safe to re-run: existing configs are backed up, and installs are idempotent where possible.
#
# Reference article (for background): https://fedoramagazine.org/configuring-neovim-on-fedora-as-an-ide-and-using-lazyvim/

set -euo pipefail

info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
err()  { echo -e "\033[1;31m[ERROR]\033[0m $*"; }

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    err "Required command '$1' not found."
    exit 1
  fi
}

# --- Detect Fedora/dnf ---
if ! command -v dnf >/dev/null 2>&1; then
  err "This script is intended for Fedora (dnf not found)."
  exit 1
fi

# --- Install base dependencies ---
info "Installing Neovim and common developer tools via dnf..."
sudo dnf -y install \
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
  python3-pip || true

# Optional: lazygit if available in repos
if dnf info lazygit >/dev/null 2>&1; then
  info "Installing lazygit..."
  sudo dnf -y install lazygit || warn "Failed to install lazygit (optional)."
else
  warn "'lazygit' not found in repos; skipping (optional)."
fi

# Ensure python neovim support (some plugins/tools rely on it)
python3 -m pip install --user --upgrade pynvim >/dev/null 2>&1 || true

# --- Backup any existing Neovim config ---
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_DATA_DIR="$HOME/.local/share/nvim"
NVIM_STATE_DIR="$HOME/.local/state/nvim"
NVIM_CACHE_DIR="$HOME/.cache/nvim"
BACKUP_SUFFIX="backup_$(date +%Y%m%d_%H%M%S)"

backup_if_exists() {
  local p="$1"
  if [ -e "$p" ]; then
    local dest="${p}_${BACKUP_SUFFIX}"
    info "Backing up $p -> $dest"
    mv "$p" "$dest"
  fi
}

info "Backing up any existing Neovim directories..."
backup_if_exists "$NVIM_CONFIG_DIR"
backup_if_exists "$NVIM_DATA_DIR"
backup_if_exists "$NVIM_STATE_DIR"
backup_if_exists "$NVIM_CACHE_DIR"

# --- Bootstrap LazyVim starter ---
info "Cloning LazyVim starter into $NVIM_CONFIG_DIR ..."
git clone --depth=1 https://github.com/LazyVim/starter "$NVIM_CONFIG_DIR"
rm -rf "$NVIM_CONFIG_DIR/.git"

# --- Add extra popular plugins via LazyVim spec ---
# We'll create a custom plugin spec at: ~/.config/nvim/lua/plugins/extras.lua
PLUGINS_DIR="$NVIM_CONFIG_DIR/lua/plugins"
mkdir -p "$PLUGINS_DIR"

cat > "$PLUGINS_DIR/extras.lua" <<'EOF'
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

# --- Initial plugin sync (headless) ---
require_cmd nvim
info "Syncing plugins headlessly (this may take a while on first run)..."
nvim --headless "+Lazy! sync" +qa || true

info "All done! Launch Neovim with: nvim"
info "Your config is in: $NVIM_CONFIG_DIR"
