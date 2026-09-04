# Workstation capability parity

Матрица показывает функциональное покрытие bootstrap-профилей, а не полное
совпадение пакетов. Fedora остаётся reference implementation. `Partial` означает,
что базовый сценарий закрыт, но не все Fedora-инструменты имеют native-аналог.

| Capability | Fedora | macOS | Windows | WSL | Notes |
| --- | --- | --- | --- | --- | --- |
| Base CLI | Full | Full | Full | Full | Git, curl, jq/yq и файловые утилиты |
| Modern CLI | Full | Full | Full | Full | rg, fd, fzf, bat, eza, zoxide |
| Shell | Zsh/Bash | Zsh | PowerShell 7 | Bash/Zsh | Native shell соответствует платформе |
| Git | Full | Full | Full | Full | Personal identity не записывается bootstrap-скриптами |
| Editors | Full | Full | Full | Shared host editors | VS Code/VSCodium; Fedora также ставит AI forks |
| AI coding tools | Full | Antigravity + editors | Antigravity + editors | CLI tools as needed | Antigravity входит в профили всех платформ |
| Browsers | Full | Full | Full | Host browser | Platform-native packages |
| Office | Full | Full | Full | Host apps | LibreOffice |
| Multimedia | Full | Full | Full | Host apps | Native players differ |
| Screenshots | Full | Full | Full | Host apps | GNOME tools, Flameshot/Rectangle, ShareX |
| Networking | Full | Full | Partial | Full | Low-level Linux diagnostics лучше выполнять в WSL |
| Packet analysis | Wireshark/tcpdump | Wireshark/tcpdump | Wireshark | tcpdump | Capture permissions require separate setup |
| VPN | Full | External/backup | External/backup | As needed | Profiles and keys never belong in git |
| Remote access | Full | SSH | OpenSSH/WinSCP/RustDesk | SSH | Use keys and host-key verification |
| Backup/sync | rclone/restic/borg | rclone/restic | rclone/restic | Full | Offline assets live in repository №2 |
| Encryption/passwords | age/SOPS/KeePassXC/VeraCrypt | age/SOPS/KeePassXC/VeraCrypt | age/SOPS/KeePassXC/VeraCrypt | age/SOPS | Secrets remain outside the repository |
| Databases | Full | libpq + DBeaver | DBeaver | Linux clients | Fedora has the broadest native client set |
| API tools | HTTPie/gRPCurl/k6 | HTTPie/gRPCurl/k6 | HTTPie/gRPCurl/k6 | Full | Postman/Insomnia are optional GUI clients |
| IaC | Full | Full | Full | Full | OpenTofu/Terraform, Terragrunt, Packer, Ansible where appropriate |
| Containers | Docker/Podman | Docker/Podman Desktop | Docker/Podman Desktop | Engine integration | Do not run two engines unless needed |
| Kubernetes | Full | Full | Full | Full | kubectl, Helm, Kustomize, k9s, kind, stern |
| Cloud CLI | AWS/Azure and optional others | AWS/Azure/gcloud | AWS/Azure/gcloud | Full | Authentication state is not backed up to git |
| Languages | Python/Go/Java/Rust/Node | Python/Go | Python/Go | Full | Install project versions with project tooling when required |
| Linters/security | Full | Full | Partial | Full | ShellCheck, TFLint, Trivy, Cosign, Syft/Grype |
| Virtualization | KVM/libvirt | Docker/Podman VM backends | WSL2/Hyper-V backends | N/A | Platform-native implementation |
| Hardware/Arduino | Full | Not in bootstrap | Not in bootstrap | N/A | Optional; Fedora is the reference workstation |

Package availability changes independently of this repository. Bootstrap scripts
check the relevant package manager at runtime and report unavailable items rather
than silently claiming parity.
