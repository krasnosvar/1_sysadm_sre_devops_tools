# Fedora Workstation Scripts

Скрипты для восстановления и настройки Fedora workstation после чистой установки.
Запускаются из этой папки.

```bash
cd 1_linux/fedora   # relative to the repo root
```

## Порядок запуска

```bash
./1_fedora-desktop-44-update.sh
./2_config_zsh.sh
./3_config_nvim.sh
./4_config_vscode.sh
./5_ai_tools.sh
```

После `2_config_zsh.sh` лучше открыть новый login shell, чтобы подтянулись `zsh`,
`PATH` и Oh My Zsh plugins.

## Что где

`1_fedora-desktop-44-update.sh`

Базовая настройка Fedora: repos, dnf/flatpak пакеты, браузеры, мультимедиа,
виртуализация, VPN/network/database/devops/programming tools.

`2_config_zsh.sh`

Zsh, Oh My Zsh, autosuggestions, syntax highlighting, powerline font, local
zsh config, OpenTofu completion. Also installs byobu + tmux (idempotent) and
configures Konsole F-keybindings (Fedora/Konsole eats modified F1-F4 by
default - only Ubuntu/GNOME Terminal gets these for free), plus the default
window set (1:htop 2:ide 3:claude 4:codex). `--check` to diagnose the
byobu/Konsole part only, `--revert` to undo it.

`3_config_nvim.sh`

Neovim + LazyVim. Если рабочий `~/.config/nvim` уже есть, скрипт его сохраняет и
только доставляет зависимости/extra plugins.

`4_config_vscode.sh`

VS Code, VSCodium, Cursor, Windsurf, Google Antigravity, общий `settings.json`,
extensions, `~/AGENTS.md`, `~/.cursor/mcp.json`.

`5_ai_tools.sh`

AI tools: Cursor/Windsurf/Google Antigravity repos, Claude Code, Codex, Gemini CLI,
Qwen Code, Crush, Aider, opencode, goose, Warp, LM Studio CLI/AppImage launcher,
AnythingLLM Desktop.

`lib_fedora_setup.sh`

Общие функции для скриптов: проверка Fedora, idempotent dnf/npm installs,
безопасная запись файлов, git clone/update.

`fedora_docs.sh`

Заметка-ссылка на переключение desktop environment (GNOME) в официальной
документации Fedora - ничего не устанавливает.

`fedora-coreos/`

Отдельно от основного workflow: разворачивание Fedora CoreOS VM на libvirt/KVM
(`pure_install_on_libvirt.sh`, `coreos-libvirt-terraform/` - Terraform + minikube,
`create_vm_by_bash_command/` - Ignition config примеры).

## Повторный запуск

Скрипты рассчитаны на повторный запуск:

- dnf-пакеты проверяются перед установкой там, где это уже вынесено в helpers;
- npm global packages ставятся в user prefix `~/.local`, не в `/usr/local`;
- repo/config файлы перезаписываются только при изменении там, где используется
  `write_file_if_changed`;
- git-based tools обновляются через `git pull --ff-only`.

Главный системный скрипт большой и все еще делает много внешних установок. Его
лучше запускать осознанно, особенно на уже настроенной машине.

## Приватные данные

Не класть секреты в git. Хранить отдельно, например:

```bash
mkdir -p "$HOME/.config/workstation-restore"
chmod 700 "$HOME/.config/workstation-restore"
```

Туда или в encrypted backup:

- `private.env`;
- `~/.ssh/`, `~/.gnupg/`, `~/.aws/`;
- kubeconfigs и cloud CLI profiles;
- VPN configs, WireGuard/OpenVPN keys;
- SOPS age keys, password stores, KeePass databases;
- MCP configs с реальными токенами.

Публичный шаблон: `private/private.env.sample`.

## Быстрая проверка

```bash
bash -n ./*.sh
command -v codex && codex --version
npm config get prefix
```

Ожидаемый npm prefix:

```text
$HOME/.local
```
