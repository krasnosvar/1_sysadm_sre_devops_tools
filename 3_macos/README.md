#### MacOS scripts

```
├── commands.zsh
├── fedora-asahi-update.sh
├── remap-keyboard.sh
├── update-mac.zsh
└── .zshrc_mac
```


1. ```update-mac.zsh``` MacOS packages installation script via brew
2. ```fedora-asahi-update.sh``` Linux for Mac update script
3. ```commands.zsh``` useful commands for mac
4. ```remap-keyboard.sh``` tools for remap macos-keyboard to win-keyboard
5. ```.zshrc_mac``` zsh config for mac

`update-mac.zsh` is intended to mirror the Fedora workstation setup where
possible: CLI tools, browsers, media apps, DevOps/Kubernetes tooling, database
clients, IDEs, Arduino tools and AI tools. macOS-specific open-source
alternatives are used where there is no direct Linux equivalent.

Private tokens, VPN profiles, SSH/GPG keys, cloud credentials and MCP secrets
must stay outside this public repo. Use an encrypted backup or a local directory
such as `~/.config/workstation-restore`.
