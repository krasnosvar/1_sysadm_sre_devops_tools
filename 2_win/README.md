# Windows 11 scripts

`choco.ps1` — idempotent bootstrap for Windows PowerShell 5.1+ / PowerShell 7. It checks already installed packages, continues after an unavailable package, and returns an overall failure summary.

```powershell
# Read-only preview, elevation is not required
pwsh -File .\choco.ps1 -Profile DevOps -WhatIf

# Run from an elevated PowerShell session
pwsh -File .\choco.ps1 -Profile All

# Add/update WSL2 and install the moving Ubuntu Store distribution
pwsh -File .\choco.ps1 -Profile DevOps -InstallWSL
```

Profiles: `Minimal`, `DevOps`, `Desktop`, `All`. `Minimal` is used by default. Google Antigravity is included in `DevOps` and `Desktop`. Ansible and other Linux-centric tools should be run in WSL, while native `kubectl`, cloud CLIs, and container clients are left for the Windows workflow.

`powershell.sh` — command-reference fragments, not an executable shell script.
`win11_lock_screen.png` — optional personal asset.

A full offline manifest of applications is located in [`2_lin_win_mac_apps_bkp`](https://github.com/krasnosvar/2_lin_win_mac_apps_bkp).
Credentials, SSH keys, kubeconfig, and VPN profiles must not be committed to the repo.
