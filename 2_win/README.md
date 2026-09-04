# Windows 11 scripts

`choco.ps1` — идемпотентный bootstrap для Windows PowerShell 5.1+ / PowerShell 7. Он проверяет уже
установленные пакеты, продолжает после недоступного package и возвращает общий
failure summary.

```powershell
# Read-only preview, elevation is not required
pwsh -File .\choco.ps1 -Profile DevOps -WhatIf

# Run from an elevated PowerShell session
pwsh -File .\choco.ps1 -Profile All

# Add/update WSL2 and install the moving Ubuntu Store distribution
pwsh -File .\choco.ps1 -Profile DevOps -InstallWSL
```

Профили: `Minimal`, `DevOps`, `Desktop`, `All`. `Minimal` используется по
умолчанию. Google Antigravity входит в `DevOps` и `Desktop`. Ansible и другие
Linux-centric tools следует запускать в WSL, а
native `kubectl`, cloud CLI и container clients оставлены для Windows workflow.

`powershell.sh` — command-reference fragments, а не исполняемый shell script.
`win11_lock_screen.png` — optional personal asset.

Полный offline manifest приложений находится в
[`2_lin_win_mac_apps_bkp`](https://github.com/krasnosvar/2_lin_win_mac_apps_bkp).
Credentials, SSH keys, kubeconfig и VPN profiles не должны попадать в репу.
