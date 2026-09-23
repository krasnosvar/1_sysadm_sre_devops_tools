# macOS scripts

`update-mac.zsh` — the main idempotent bootstrap using Homebrew. It does not set Git name/email, does not copy secrets, and correctly handles Homebrew paths on both Apple Silicon and Intel.

```bash
./update-mac.zsh --check
./update-mac.zsh --devops --dry-run
./update-mac.zsh --all
```

Profiles: `--minimal`, `--devops`, `--desktop`, `--all`. Google Antigravity is included in `devops` and `desktop`. Unavailable formulas/casks do not stop the entire run, but are listed at the end and result in an exit code 1.

Other files:

- `.zshrc_mac` — a portable fragment that the bootstrap installs into `~/.config/sre-tools/zshrc`;
- `commands.zsh` — macOS command-reference fragments;
- `fedora-asahi-update.sh` — a separate legacy Fedora Asahi setup, not part of the macOS bootstrap;
- `remap-keyboard.sh` — notes on keyboard remapping.

A large offline catalog of installers and package manifests belongs to the [`2_lin_win_mac_apps_bkp`](https://github.com/krasnosvar/2_lin_win_mac_apps_bkp) repository.
SSH/GPG keys, VPN profiles, cloud credentials, and MCP tokens are stored outside of git.
