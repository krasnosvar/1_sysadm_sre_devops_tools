#### Win11 scripts

```
.
├── README.md
├── choco.ps1
├── powershell.sh
└── win11_lock_screen.png
```


1. ```choco.ps1``` Win11 packages installation script via chocolatey
* Execute script with admin privileges
```
powershell -executionpolicy bypass -File 'C:\Users\Den\Documents\choco.ps1'
```
The package list mirrors the Fedora workstation setup where Windows packages are
available: CLI utilities, browsers, media apps, DevOps/Kubernetes tooling,
database clients, IDEs, Arduino tools and AI tools. Windows-specific
open-source alternatives are used where there is no direct Linux equivalent
(`ShareX`, `Greenshot`, `SumatraPDF`, `WinDump`, `WinMTR`, `WinSCP`, etc.).

Do not store private SSH/GPG keys, VPN profiles, cloud credentials, MCP tokens
or API keys in this public repo. Keep them in an encrypted backup or a local
restore folder outside git.

* update installed via choco packages
* https://docs.chocolatey.org/en-us/choco/commands/upgrade/
```
choco upgrade all
```


2. ```powershell.sh``` some useful Powershell commands 
