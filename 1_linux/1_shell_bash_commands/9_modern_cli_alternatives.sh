#!/usr/bin/env bash
# Modern CLI alternatives — faster and friendlier replacements for classic tools
# Most available via: dnf install / apt install / brew install
# Full list: https://github.com/ibraheemdev/modern-unix

# ── bat (replaces cat) ────────────────────────────────────────────────────────
# syntax highlighting, line numbers, git change markers, pager built-in
bat file.py                        # syntax-highlighted view
bat -n file.py                     # no pager, just line numbers
bat -A file.conf                   # show non-printable characters
bat --diff file.py                 # show only changed lines (git)
# set as default: alias cat=bat

# ── eza (replaces ls) ─────────────────────────────────────────────────────────
# icons, git status per file, tree view, colors
eza --long --git                   # ls -l with git status column
eza -la                            # show hidden files
eza --tree --level=2               # tree view 2 levels deep
eza --sort=modified                # sort by modification time
eza --group-directories-first -la  # dirs first
# recommended aliases:
# alias ls='eza --group-directories-first'
# alias ll='eza -la --git'
# alias lt='eza --tree --level=2'

# ── fd (replaces find) ────────────────────────────────────────────────────────
# faster, respects .gitignore, intuitive syntax
fd pattern                         # find files matching pattern (current dir)
fd -e py                           # find by extension
fd -t d config                     # find directories named "config"
fd -H '^\.env'                     # include hidden files, match .env*
fd -e log --exec rm {}             # delete all .log files
fd -e sh --exec chmod +x {}        # make all .sh files executable
fd --changed-within 1d             # files modified in last 24h

# ── ripgrep (rg, replaces grep) ───────────────────────────────────────────────
# 3–10x faster than grep, respects .gitignore, binary-safe
rg 'TODO'                          # search recursively from current dir
rg 'TODO' src/                     # search in directory
rg -l 'error'                      # list files containing match
rg -i 'pattern'                    # case-insensitive
rg -t py 'def '                    # search only in .py files
rg -t yaml 'image:'                # in YAML files
rg --no-ignore 'secret'            # also search .gitignored files
rg -A 3 -B 3 'panic'              # 3 lines context around match
rg 'func\s+\w+' --pcre2           # PCRE2 regex (lookahead etc.)

# ── fzf (fuzzy finder) ────────────────────────────────────────────────────────
# interactive fuzzy search over any list; integrates with shell history/cd/vim
fzf                                # pick a file interactively
fzf --preview 'bat --color=always {}'  # with file preview
vim $(fzf)                         # open selected file in vim

# Shell integration (add to .zshrc / .bashrc):
# CTRL-R  — fuzzy history search
# CTRL-T  — fuzzy file picker
# ALT-C   — fuzzy cd into directory
# source /usr/share/fzf/shell/key-bindings.zsh  (path varies by distro)

# combined with other tools:
git log --oneline | fzf            # fuzzy pick commit
kubectl get pods | fzf             # fuzzy pick pod
ps aux | fzf | awk '{print $2}'    # fuzzy pick PID

# ── zoxide (replaces cd) ──────────────────────────────────────────────────────
# remembers frequently visited dirs; jump with partial name
z projects                         # jump to ~/my_projects (most frequent match)
z infra dev                        # match path containing both "infra" and "dev"
zi                                 # interactive fzf picker of recent directories
# init (add to .zshrc): eval "$(zoxide init zsh)"

# ── atuin (replaces shell history) ───────────────────────────────────────────
# encrypted sync across machines, SQLite backend, stats
atuin search 'kubectl'             # search history
atuin stats                        # most used commands
atuin history list --cmd-only      # plain list
# CTRL-R in shell shows atuin's interactive TUI search
# init: eval "$(atuin init zsh)"

# ── btop (replaces top/htop) ──────────────────────────────────────────────────
# full TUI: CPU/MEM/DISK/NET per-process, mouse support, themes
btop                               # launch interactive monitor

# ── duf (replaces df) ─────────────────────────────────────────────────────────
# colorful disk usage with bar charts
duf                                # all mounts
duf /home /var                     # specific paths
duf --only local                   # skip network/tmpfs mounts
duf --output mountpoint,size,avail,use%  # custom columns

# ── dust (replaces du) ────────────────────────────────────────────────────────
# visual tree of disk usage, sorted by size
dust                               # current directory
dust /var/log                      # specific path
dust -n 20                         # top 20 entries
dust -d 2                          # max depth 2
dust -r                            # reverse order (smallest first)

# ── glow (markdown renderer) ──────────────────────────────────────────────────
# render Markdown in terminal with colors, paging
glow README.md
glow .                             # pick from all .md files in dir
glow -p README.md                  # pager mode (like less)

# ── delta (replaces diff for git) ─────────────────────────────────────────────
# syntax-highlighted git diffs with side-by-side mode
# configure in ~/.gitconfig:
# [core]
#   pager = delta
# [delta]
#   navigate = true
#   side-by-side = true
#   line-numbers = true
# [interactive]
#   diffFilter = delta --color-only

git diff                           # now uses delta automatically
git show HEAD                      # also highlighted

# ── starship (shell prompt) ───────────────────────────────────────────────────
# cross-shell prompt: shows git branch, k8s context, terraform workspace,
# Python/Node/Go version, last command exit code — all fast (Rust)
# init: eval "$(starship init zsh)"
# config: ~/.config/starship.toml

# ── Quick install (Fedora) ────────────────────────────────────────────────────
# dnf install bat eza fd-find ripgrep fzf zoxide btop glow
# cargo install du-dust duf atuin   # or: brew install dust duf atuin
# curl -sS https://starship.rs/install.sh | sh
