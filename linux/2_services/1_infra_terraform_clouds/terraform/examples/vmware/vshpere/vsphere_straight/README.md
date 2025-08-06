### Creating VM through terraform directly in Vsphere

* Ansible role creates:
- Empty VM (any number) with any hardware (by default: 1 VM 4 CPU 4RAM 52HDD)
- Template for stand (hard-coded number of VMs)
- Hosts file for VM configuration

* Parameters that can be passed when called:
```
ACTION= create destroy refresh
application= SUAG APP2 CO
vm_count= 1
cpu= 4 8 16
memory= 4096 8192 16384 32768
storage= 52 
```

1. To create empty VM:
- need to call role, passing only path to ```terraform``` folder
```
ansible-playbook ansible/create_terraform.yml \
--extra-vars="terra_dir=terraform_test service_account_passw= ACTION=create" -v
```

2. To create several VMs (any number) and (if needed) custom hardware
```
ansible-playbook ansible/create_terraform.yml \
--extra-vars="vm_count=5 cpu=8 memory=16384 terra_dir=terraform_test service_account_passw= ACTION=create" -v
```

3. Creating VM for application stand ```APP1``` ```APP2``` ```APP3```
```
ansible-playbook ansible/create_terraform.yml \
--extra-vars="application=APP2 terra_dir=terraform_test service_account_passw= ACTION=create" -v
```

3. Adding target to Prometheus server
```
ansible-playbook ansible/add_remove_target_to_srv.yml \
--extra-vars="application=CO ACTION=create" -v
```

4. Removal 
```
ansible-playbook ansible/create_terraform.yml \
--extra-vars=" terra_dir=terraform_test service_account_passw= ACTION=destroy" -v
```


***
5. VAULT example cmd
```
ansible-vault encrypt ansible/roles/deploy_env_config/templates/APP2/bp_env_config.j2 --vault-password-file ansible/vault_pass.txt
```


6. UPD

* python-script creates cloud-init files for network configuration from given IP range if VMs don't pick up DHCP
