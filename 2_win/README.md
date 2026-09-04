# Windows 11 scripts

`choco.ps1` — полный workstation bootstrap для Windows PowerShell 5.1+ /
PowerShell 7. Он сохраняет исходный каталог приложений, проверяет уже
установленные пакеты, продолжает после недоступного package и возвращает общий
failure summary.

```powershell
# Read-only preview, elevation is not required
pwsh -File .\choco.ps1 -WhatIf

# Install the selected applications and configure editors, AI CLI tools and WSL
# Run from an elevated PowerShell session after reviewing the preview
pwsh -File .\choco.ps1
```

В `$Packages`, `$Extensions`, `$EditorCommands` и `$AITools` каждый элемент
записан на отдельной строке и сгруппирован по назначению. Закомментируйте или
удалите строку приложения, расширения либо CLI, которое не нужно, затем снова
запустите `-WhatIf`. По умолчанию после Chocolatey packages устанавливаются
расширения редакторов, Claude Code, Codex, Gemini CLI и настраивается WSL2 с
Ubuntu. Google Antigravity сохранён и в списке приложений, и среди редакторов.

`powershell.sh` — command-reference fragments, а не исполняемый shell script.
`win11_lock_screen.png` — optional personal asset.

Полный offline manifest приложений находится в
[`2_lin_win_mac_apps_bkp`](https://github.com/krasnosvar/2_lin_win_mac_apps_bkp).
Credentials, SSH keys, kubeconfig и VPN profiles не должны попадать в репу.
