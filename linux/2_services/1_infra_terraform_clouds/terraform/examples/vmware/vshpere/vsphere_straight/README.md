### Создание ВМ через terraform напрямую в Vsphere

* Ansible-роль создает:
- Пустую ВМ( любое кол-во) и с любым железом( по умолчанию: 1 ВМ 4 CPU 4RAM 52HDD)
- Шаблон для стенда ( жестко заданное кол-во ВМ)
- Hosts-файл для конфигурации ВМок

* Параметры, которые можно передавать при вызове:
```
ACTION= create destroy refresh
application= SUAG APP2 CO
vm_count= 1
cpu= 4 8 16
memory= 4096 8192 16384 32768
storage= 52 
```

1. Для создания пустой ВМ:
- необходимо вызвать роль, передав только путь до папки  ```terraform```
```
ansible-playbook ansible/create_terraform.yml \
--extra-vars="terra_dir=terraform_test service_account_passw= ACTION=create" -v
```

2. Для создания нескольких ВМ (любое кол-во) и (если нужно) кастомного железа
```
ansible-playbook ansible/create_terraform.yml \
--extra-vars="vm_count=5 cpu=8 memory=16384 terra_dir=terraform_test service_account_passw= ACTION=create" -v
```

3. Создание ВМ под стенд приложения ```APP1``` ```APP2``` ```APP3```
```
ansible-playbook ansible/create_terraform.yml \
--extra-vars="application=APP2 terra_dir=terraform_test service_account_passw= ACTION=create" -v
```

3. Добавление таргета на сервер Прометеус
```
ansible-playbook ansible/add_remove_target_to_srv.yml \
--extra-vars="application=CO ACTION=create" -v
```

4. Удаление 
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

* python-script создает cloud-init файлы для конфигурации сети из заданного диапазона IP-адресов если Вмки не подхватывают DHCP
