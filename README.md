# SysAdmin / SRE / DevOps guide: 
diagnostic commands, working configurations, automation utilities, and workstation recovery scripts. This repository answers the question "how to perform an operational task" and does not duplicate the educational knowledge bases of the series.

## Quick Navigation

| Section | Purpose |
| --- | --- |
| [`1_linux/`](1_linux/) | Linux command reference, service examples, and main automation toolkit |
| [`1_linux/fedora/`](1_linux/fedora/) | Primary/reference bootstrap for Fedora Workstation |
| [`1_linux/ubuntu/`](1_linux/ubuntu/) | Ubuntu bootstrap and explicitly marked archive of older versions |
| [`1_linux/3_scripts_bash_python/`](1_linux/3_scripts_bash_python/) | Ready-to-use Bash/Python/Go utilities for operational tasks |
| [`2_win/`](2_win/) | Windows/PowerShell bootstrap and commands |
| [`3_macos/`](3_macos/) | macOS and Fedora Asahi bootstrap |
| [`what_to_learn/`](what_to_learn/) | Saved legacy notes and pointers to canonical educational repositories |

The `.sh` files in the command-reference directories are readable command fragments with shell highlighting. They are not necessarily complete executable programs. Files explicitly marked as utilities or bootstrap scripts are considered executable.

## How to Choose an Automation Language

| Task | Default Tool | Why |
| --- | --- | --- |
| Call multiple system commands sequentially, glue Unix tools, create a runbook | Bash | Minimal dependencies and direct CLI access |
| Reliably parse or modify JSON/YAML/CSV, call APIs, process data | Python | Strong libraries and clear data model |
| Check the network concurrently, write a long-lived agent/exporter or a portable static binary | Go | Goroutines, `context`, strict typing, and simple deployment |
| Declaratively describe a configuration or resource | YAML/HCL/Ansible | Data and desired state are not masked by procedural code |

If a task can be solved with a short `jq`, `yq`, or `kubectl` call, a new script is not needed. Python or Go are chosen only when they significantly improve reliability, testability, or performance.

## Related Repositories

| Repository | Owns Content |
| --- | --- |
| [`2_lin_win_mac_apps_bkp`](https://github.com/krasnosvar/2_lin_win_mac_apps_bkp) | Offline copies of installers, ISOs, and package manifests |
| [`3_go_my_knowledgebase`](https://github.com/krasnosvar/3_go_my_knowledgebase) | Learning Go, concurrency, backend, and system design |
| [`4_python_my_knowledgebase`](https://github.com/krasnosvar/4_python_my_knowledgebase) | Learning Python, libraries, backend, and system design |
| [`5_devops_sre_knowledgebase`](https://github.com/krasnosvar/5_devops_sre_knowledgebase) | Theory, labs, and roadmap for DevOps/SRE/MLOps |

New theory, exercises, and mini-projects should be modified in the corresponding knowledgebase. Old notes in `what_to_learn/` are preserved until a verified migration; having a copy here does not make it the canonical source.

## Security

- Do not commit secrets, kubeconfig, SSH/VPN keys, or working inventories.
- Always check placeholders, environments, and destructive flags before a real run.
- Old examples may be saved as historical/reference and require review.
- Run bootstraps with `--check` or `--dry-run` first, if the mode is supported.

## Checks

GitHub Actions verifies maintained Bash/Zsh/PowerShell scripts, compiles Go utilities (`gofmt`, `go vet`, `go test`), and runs Ruff for Python. The checks do not execute workstation installers. Command-reference `.sh` files are intentionally excluded from `bash -n`: some of them contain command outputs and configs for copying.
