##### Most used ( by myself ) linux build-in commands and utilities 

```
.
├── 0_oneliners.sh
├── 1_kernel_hard_system_ps
├── 2_disks_mount_lvm_nfs
├── 3_users_and_groups
├── 4_network_utils_commands
├── 5_packages_apt_yum_pip
├── 6_text_manipulation_utils
├── 7_files_folders_manipulation_utils
├── 8_sh_bash_zsh_scripting
├── 9_modern_cli_alternatives.sh
├── 10_containers_k8s
├── 11_virt_iac_cloud
├── 12_monitoring_logs
├── 13_db_storage
├── 14_services
├── direnv.sh
└── README.md
```

0. [`0_oneliners.sh`](0_oneliners.sh) - oneline commands to do common things (update packages, list and delete "deleted" files, generate password, etc. )
1. [`1_kernel_hard_system_ps/`](1_kernel_hard_system_ps/) - kernel and hardware utils (cpu, sysctl, procfs, devfs/udev, systemd/sysV, ntp/chrony, lsof, wi-fi, GRUB2, SELinux, OOM killer), performance diagnostics (vmstat, iostat, pidstat, sar, strace, perf, bpftrace/bcc)
2. [`2_disks_mount_lvm_nfs/`](2_disks_mount_lvm_nfs/) - disk utils: dd, parted, lvm, mount, nfs, multipath, smartctl, NVMe/SSD wear, swap
3. [`3_users_and_groups/`](3_users_and_groups/) - users/groups: useradd, chmod, acl, sudo, ldapsearch, vipw, sssd
4. [`4_network_utils_commands/`](4_network_utils_commands/) - network: ip, ssh/sshpass, curl/wget, dig, nmap, tcpdump, iptables/firewalld/ufw, nftables, mtr/traceroute, WireGuard, certbot, samba, wi-fi
5. [`5_packages_apt_yum_pip/`](5_packages_apt_yum_pip/) - package managers: apt/dpkg/yum, dnf/rpm, flatpak, pip, uv/pipx, snap
6. [`6_text_manipulation_utils/`](6_text_manipulation_utils/) - text tools: awk, sed, grep, additional safe grep/rg and jq/yq v4 examples, cut, sort, xargs, delta
7. [`7_files_folders_manipulation_utils/`](7_files_folders_manipulation_utils/) - file/folder tools: find, cp, rm, rename, zip/tar/7z, trash-cli, zoxide
8. [`8_sh_bash_zsh_scripting/`](8_sh_bash_zsh_scripting/) - shell scripting: bash/zsh basics, crontab/at, history, completion, tealdeer, lazygit; byobu/tmux, vim
9. [`9_modern_cli_alternatives.sh`](9_modern_cli_alternatives.sh) - modern drop-in replacements: bat, eza, fd, ripgrep, fzf, zoxide, atuin, btop, duf, dust, glow, delta, starship
10. [`10_containers_k8s/`](10_containers_k8s/) - docker, podman, kaniko, crictl, kubectl (+ plugins), kustomize, helm (+ helm-secrets), argocd, etcdctl, k9s, kubeconfig/RBAC users
11. [`11_virt_iac_cloud/`](11_virt_iac_cloud/) - KVM/virsh, terraform, cloud-init, ansible (+ vault, galaxy, venv), gitlab, DigitalOcean, Yandex Cloud, sops/age/gpg, VMware vSphere/vRA example
12. [`12_monitoring_logs/`](12_monitoring_logs/) - Prometheus, Loki, VictoriaMetrics, tracing, Elasticsearch, rsyslog, logrotate
13. [`13_db_storage/`](13_db_storage/) - PostgreSQL (install, config, psql, users, tables, dump/restore), MySQL, MongoDB, SQL syntax, MinIO mc
14. [`14_services/`](14_services/) - nginx, keepalived, apcupsd
15. [`direnv.sh`](direnv.sh) - direnv setup and usage
