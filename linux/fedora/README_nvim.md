# Fedora Neovim + LazyVim Setup

This document explains how to use `3_config_nvim.sh` to install Neovim and a curated LazyVim setup on Fedora.

## What the script does

- __Installs packages__: `neovim`, `git`, `curl`, `wget`, `ripgrep`, `fd-find`, `unzip`, `tar`, `make`, `gcc`, `nodejs`, `npm`, `python3`, `python3-pip`.
- __Optionally installs__: `lazygit` (if available in Fedora repos).
- __Backs up__ existing Neovim paths to `*_backup_YYYYMMDD_HHMMSS`:
  - `~/.config/nvim`
  - `~/.local/share/nvim`
  - `~/.local/state/nvim`
  - `~/.cache/nvim`
- __Bootstraps__ LazyVim starter into `~/.config/nvim`.
- __Adds extra popular plugins__ via `~/.config/nvim/lua/plugins/extras.lua`.
- __Performs headless sync__: runs `nvim --headless "+Lazy! sync" +qa` so plugins install on first run.

## Included plugins (in addition to LazyVim defaults)

- `nvim-lualine/lualine.nvim` – statusline
- `nvim-tree/nvim-tree.lua` – file explorer
- `nvim-telescope/telescope.nvim` + `telescope-fzf-native.nvim` – fuzzy finder
- `nvim-treesitter/nvim-treesitter` – better syntax/AST with common languages preselected
- `numToStr/Comment.nvim` – line/block comments
- `lewis6991/gitsigns.nvim` – git gutters
- `akinsho/bufferline.nvim` – buffer tabs
- `lukas-reineke/indent-blankline.nvim` – indent guides
- `windwp/nvim-autopairs` – auto pairs
- `folke/which-key.nvim` – keybinding hints
- `catppuccin/nvim` theme (macchiato)

## How to use

1. __Make executable__ (first time only):
   ```bash
   chmod +x 3_config_nvim.sh
   ```
2. __Run the script__:
   ```bash
   ./3_config_nvim.sh
   ```
   You will be prompted for sudo to install packages via `dnf`.
3. __Start Neovim__:
   ```bash
   nvim
   ```
   On first launch, Lazy.nvim may finalize installs and Treesitter parsers.

## After install

- Config path: `~/.config/nvim`
- Extra plugin spec: `~/.config/nvim/lua/plugins/extras.lua`
- Update plugins inside Neovim:
  - `:Lazy sync` to update/sync
  - `:TSUpdate` to update Treesitter parsers

## Common keybinds (LazyVim defaults)

- Leader key: `<space>`
- File explorer: `<space> e` (NvimTreeToggle)
- Find files: `<space> f f`
- Live grep: `<space> f g`
- Buffers: `<space> b b`
- Key help: `<space> ?` (which-key)

## Fonts (optional but recommended)

Install a Nerd Font so icons render correctly, e.g. JetBrainsMono Nerd Font:
```bash
sudo dnf copr enable peterwu/iosevka -y || true
# Or download from https://www.nerdfonts.com/ and install manually
```
Then select it in your terminal emulator.

## Troubleshooting

- If plugin compilation fails for `telescope-fzf-native.nvim`, ensure `make` and a C toolchain are installed (the script installs `make` and `gcc`).
- If `fd` is missing, Fedora provides it as `fd-find`. The binary may be `fd` or `fdfind` depending on your PATH. Telescope works without `fd`, but it's nice to have.
- If `ripgrep` (rg) is missing from PATH, rerun the script or install via `sudo dnf -y install ripgrep`.

## Uninstall / reset

To reset to a clean state (this removes current config and cache):
```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```
Then rerun `./3_config_nvim.sh` to reinstall.

## Notes

- The script is idempotent and safe to rerun; existing configs are backed up with a timestamp.
- Background reading: https://fedoramagazine.org/configuring-neovim-on-fedora-as-an-ide-and-using-lazyvim/
