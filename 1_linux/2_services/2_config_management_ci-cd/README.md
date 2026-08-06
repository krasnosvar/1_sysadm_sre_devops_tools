#### Configuration management and CI/CD

```
.
├── ansible
│   ├── ansible.cfg, ansible.sh, ansible_galaxy.sh, vault_ansible.sh
│   ├── ansible_via_venv.md      - running ansible from a Python venv
│   ├── avoid_templating_in_playbook.yml
│   ├── playbooks_samples
│   ├── roles_samples
│   └── vars
└── gitlab
    ├── gitlab.sh
    └── Rails_add_user_in_rails_console.sh
```

1. [ansible](ansible) - Ansible commands, Galaxy/Vault usage, running via a venv, sample playbooks/roles/vars
2. [gitlab](gitlab) - self-hosted GitLab admin commands, incl. creating a user via the Rails console
