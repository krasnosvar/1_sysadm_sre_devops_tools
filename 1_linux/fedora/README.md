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

[`1_fedora-desktop-44-update.sh`](1_fedora-desktop-44-update.sh)

Базовая настройка Fedora: repos, dnf/flatpak пакеты, браузеры, мультимедиа,
виртуализация, VPN/network/database/devops/programming tools.

[`2_config_zsh.sh`](2_config_zsh.sh)

Zsh, Oh My Zsh, autosuggestions, syntax highlighting, powerline font, local
zsh config, OpenTofu completion. Also installs byobu + tmux (idempotent) and
configures Konsole F-keybindings (Fedora/Konsole eats modified F1-F4 by
default - only Ubuntu/GNOME Terminal gets these for free), plus the default
window set (1:htop 2:ide 3:claude 4:codex). `--check` to diagnose the
byobu/Konsole part only, `--revert` to undo it.

[`3_config_nvim.sh`](3_config_nvim.sh)

Neovim + LazyVim. Если рабочий `~/.config/nvim` уже есть, скрипт его сохраняет и
только доставляет зависимости/extra plugins.

[`4_config_vscode.sh`](4_config_vscode.sh)

VS Code, VSCodium, Cursor, Windsurf, Google Antigravity, общий `settings.json`,
extensions, `~/AGENTS.md`, `~/.cursor/mcp.json`.

[`5_ai_tools.sh`](5_ai_tools.sh)

AI tools: Cursor/Windsurf/Google Antigravity repos, Claude Code, Codex, Gemini CLI,
Qwen Code, Crush, Aider, opencode, goose, Warp, LM Studio CLI/AppImage launcher,
AnythingLLM Desktop. Отдельно устанавливается Antigravity CLI (`agy`).

Плагины устанавливаются в пользовательские каталоги:

- Ponytail — Codex, Claude Code и Antigravity CLI;
- Context7 — документация библиотек для Claude Code;
- Playwright — управление тестовым браузером для Claude Code.

Существующие плагины, их версии и отключённое состояние сохраняются.
Повторный запуск доставляет только отсутствующие плагины. Скрипт запускается
обычным пользователем; для системных пакетов он использует `sudo`.
После установки откройте новые сессии агентов. Для автоматического запуска
Ponytail в Codex отдельно проверьте hooks через `/hooks` и разрешите нужные.
Явный вызов: `$ponytail:ponytail full`, ревью: `$ponytail:ponytail-review`.

Вход в аккаунты, Slack/Atlassian/GitLab и доступ к рабочей Opera настраиваются
отдельно. Playwright не подключает существующие вкладки Opera. Context7
отправляет запросы документации внешнему сервису; секреты в них не передавайте.

Источники установки:

- https://github.com/DietrichGebert/ponytail/blob/main/INSTALL.md
- https://antigravity.google/docs/getting-started?tab=cli
- https://github.com/anthropics/claude-plugins-official
- https://learn.chatgpt.com/docs/chrome-extension

[`lib_fedora_setup.sh`](lib_fedora_setup.sh)

Общие функции для скриптов: проверка Fedora, idempotent dnf/npm installs,
безопасная запись файлов, git clone/update.

[`fedora_docs.sh`](fedora_docs.sh)

Заметка-ссылка на переключение desktop environment (GNOME) в официальной
документации Fedora - ничего не устанавливает.

[`fedora-coreos/`](fedora-coreos/)

Отдельно от основного workflow: разворачивание Fedora CoreOS VM на libvirt/KVM
(`pure_install_on_libvirt.sh`, `coreos-libvirt-terraform/` - Terraform + minikube,
`create_vm_by_bash_command/` - Ignition config примеры).

## AI tools: после установки

Run the installer as your normal user. Select one mode:

```bash
./5_ai_tools.sh --status        # Versions and plugin lists; no installation
./5_ai_tools.sh --plugins-only  # Missing plugins for existing agent CLIs
./5_ai_tools.sh                 # Full workstation installation/update
./5_ai_tools.sh --help
```

`--status` reports missing tools and continues. It exits nonzero when an
installed CLI fails to report its version or plugins. Plugin discovery may
contact remote catalogs; this is not an offline or authentication test.

`--plugins-only` requires `codex`, `claude`, `agy`, `git`, `jq`, and `node`
on PATH. It checks all prerequisites before changing plugin installations.
It does not install CLI agents, IDEs, desktop applications, or RPM packages.
Existing plugin versions and disabled states are preserved in both install
modes. Installation failures stop the script; completed steps are not rolled
back. Fix the reported error and rerun the same mode.

The full mode updates CLI packages and may download AnythingLLM again.
Signing-key imports, CLI updates, and LM Studio bootstrap failures stop the
script. `dnf check-update` exit code 100 is expected, not an error.

### Optional Codex MCP integrations

Ponytail is installed as a Codex plugin. Context7 and Playwright can also be
connected directly as MCP servers. These commands are separate from the
bootstrap plugin set; run them only when the named server is absent:

```bash
codex mcp list
codex mcp add context7 --url https://mcp.context7.com/mcp
codex mcp add playwright -- npx -y @playwright/mcp@latest
```

If Codex opens an OAuth flow for Context7, complete it in your browser.
To retry authentication, run `codex mcp login context7`. Restart Codex after
adding servers. Context7 sends documentation queries to its service;
anonymous access, where available, may be rate-limited. Playwright downloads its
MCP package on first use and may require a browser installation. It does not
connect to your existing Opera tabs. Configured servers are not proof of a
successful connection or browser session.

Sources:

- https://github.com/upstash/context7
- https://github.com/microsoft/playwright-mcp

В Codex ожидается Ponytail; в Claude — Ponytail, Context7 и Playwright;
в agy — Ponytail. Уже установленный, но отключённый плагин скрипт
не включает. Наличие в списке подтверждает установку, но не выполнение
hooks, авторизацию MCP или работоспособность браузера.

### Вызов Ponytail

Откройте новую сессию агента после установки. Эти строки отправляются
в чат агента, а не выполняются в Bash:

```text
Codex:
$ponytail:ponytail full
$ponytail:ponytail-review Проверь текущий diff, ничего не меняй.

Claude Code:
/ponytail:ponytail full
/ponytail:ponytail-review

Antigravity CLI:
/ponytail
```

`full` выбирает минимальное полноценное решение с необходимыми проверками.
`lite` предлагает более простой вариант; `ultra` дополнительно оспаривает
необязательные части задачи. Для выхода из режима напишите `stop ponytail`.
Это завершает режим в текущей сессии, но не удаляет плагин и не меняет
его режим по умолчанию для будущих сессий.

### Hooks и trust

Hooks — локальные команды, вызываемые агентом при определённых событиях.
В Ponytail 5.3.3 манифест для Claude/Codex содержит `SessionStart`,
`SubagentStart` и `UserPromptSubmit`: загрузка режима, передача инструкций
подагенту и отслеживание переключений режима. Они запускают Node.js-скрипты.
Набор событий и поддержка зависят от версии плагина и клиента.

Trust означает разрешение запускать показанные команды hooks. В Codex
откройте `/hooks`, проверьте источник Ponytail, пути к скриптам и события,
затем разрешите нужные команды. Откройте новую сессию и проверьте сообщение
о режиме. Если его нет, проверьте состояние плагина и ошибки hooks.
Сам факт установки не подтверждает автоматическое включение режима.

Доверие hooks разрешает исполнение кода плагина в рамках разрешений клиента.
Оно не заменяет согласование конкретных действий в рабочих системах.
Перед доверием новой версии проверяйте изменения её команд и скриптов.

### Отключение и удаление

Для отключения в Claude и agy используйте команды терминала:

```bash
claude plugin disable ponytail@ponytail --scope user
agy plugin disable ponytail
```

Для удаления из Codex:

```bash
codex plugin remove ponytail@ponytail
```

После удаления следующий запуск `5_ai_tools.sh` установит Ponytail снова.
Отключённые установленные плагины сохраняются. Удаление плагина не следует
считать очисткой всех его внешних настроек; смотрите раздел Uninstall
в инструкции Ponytail, прежде чем удалять оставшиеся файлы.

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

Публичный шаблон: [`private/private.env.sample`](private/private.env.sample).

## Быстрая проверка

```bash
(for script in ./*.sh; do bash -n "$script" || exit 1; done)
python3 tests/test_ai_tools.py
command -v codex && codex --version
npm config get prefix
```

Ожидаемый npm prefix:

```text
$HOME/.local
```
