# macOS scripts

`update-mac.zsh` — основной идемпотентный bootstrap через Homebrew. Он не
записывает Git name/email, не копирует secrets и корректно работает с путями
Homebrew на Apple Silicon и Intel.

```bash
./update-mac.zsh --check
./update-mac.zsh --devops --dry-run
./update-mac.zsh --all
```

Профили: `--minimal`, `--devops`, `--desktop`, `--all`. Google Antigravity
включён в `devops` и `desktop`. Недоступные formula/cask
не останавливают весь проход, но перечисляются в конце и дают exit code 1.

Остальные файлы:

- `.zshrc_mac` — переносимый fragment, который bootstrap устанавливает в
  `~/.config/sre-tools/zshrc`;
- `commands.zsh` — macOS command-reference fragments;
- `fedora-asahi-update.sh` — отдельный legacy Fedora Asahi setup, не часть macOS
  bootstrap;
- `remap-keyboard.sh` — заметки по remapping клавиатуры.

Большой офлайн-каталог installers и package manifests принадлежит репозиторию
[`2_lin_win_mac_apps_bkp`](https://github.com/krasnosvar/2_lin_win_mac_apps_bkp).
SSH/GPG keys, VPN profiles, cloud credentials и MCP tokens хранятся вне git.
