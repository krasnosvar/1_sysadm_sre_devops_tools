# Fedora workstation restore notes

Goal: after reinstalling Fedora, run these scripts and restore the workstation close
to the current state without committing private credentials to the public repo.

## Suggested order

1. Run `./1_fedora-desktop-43-update.sh` for repos, system packages, Flatpaks and
   development tools.
2. Run `./2_config_zsh.sh` and start a new login shell.
3. Run `./3_config_nvim.sh`.
4. Run `./4_config_vscode.sh`.
5. Run `./5_ai_tools.sh` only after Node/npm are available and after deciding
   which AI tools are still wanted.

## Private data

Keep private restore material outside git. Recommended local path:

```bash
mkdir -p "$HOME/.config/workstation-restore"
chmod 700 "$HOME/.config/workstation-restore"
```

Put these files there, or in an encrypted backup:

- `private.env` for API tokens and per-user environment variables.
- `~/.ssh/`, `~/.gnupg/`, `~/.aws/`, kubeconfigs and cloud CLI profiles.
- VPN configs, WireGuard keys, OpenVPN profiles and certificates.
- Browser profiles only if they are encrypted and intentionally backed up.
- SOPS age keys, password-store data and KeePass databases.
- IDE MCP files that contain real tokens.

Use `linux/fedora/private/private.env.sample` as the public template. Do not put
real secrets under `linux/fedora/private/`; that directory is ignored except for
`*.sample` files.

## Current machine notes from July 6, 2026

- OS: Fedora 44 KDE.
- The Cloudsmith Task repo on this machine was pointing to Fedora 43. The main
  script now writes the repo file using the detected Fedora version.
- Cursor MCP config is stored at `~/.cursor/mcp.json` on this machine, not
  `~/.config/cursor/mcp.json`.
- `.zshrc` should not export AWS credentials directly; AWS tools read
  `~/.aws/credentials` when needed.
