#### Services grouped by purpose

```
.
├── 1_infra_terraform_clouds     - cloud-init, terraform (aws/libvirt/vmware/yandex-cloud), digitalocean, kvm
├── 2_config_management_ci-cd    - ansible, gitlab
├── 3_containers_and_orchestration - docker, kaniko, kubernetes, nomad
├── 4_monitoring_and_log_tools   - elasticsearch, rsyslog
├── 5_storage_and_db_tools       - MongoDB, MySQL, PostgreSQL, minio
└── other_services               - apcupsd, nginx, samba, SELinux, sssd, vim, keepalived, etc.
```

1. [1_infra_terraform_clouds](1_infra_terraform_clouds) - cloud providers and IaC: cloud-init, Terraform examples (AWS, libvirt/KVM, VMware vSphere, Yandex Cloud), DigitalOcean, KVM
2. [2_config_management_ci-cd](2_config_management_ci-cd) - Ansible playbooks/roles, GitLab
3. [3_containers_and_orchestration](3_containers_and_orchestration) - Docker, Kaniko, Kubernetes, Nomad
4. [4_monitoring_and_log_tools](4_monitoring_and_log_tools) - Elasticsearch, rsyslog
5. [5_storage_and_db_tools](5_storage_and_db_tools) - MongoDB, MySQL, PostgreSQL, MinIO
6. [other_services](other_services) - misc services: apcupsd, browsers, byobu/tmux, exim, GRUB2, Jira, keepalived, letsencrypt/certbot, logrotate, nginx, OOM killer, OTRS, Samba, SELinux, sssd, vim
