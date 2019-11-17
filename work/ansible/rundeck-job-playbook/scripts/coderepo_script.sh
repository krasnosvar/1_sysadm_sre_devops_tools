docker pull v00rpm-dr.corp.domain.ru/dockerhub/docker-hello-world:$1
docker save --output docker-hello-world.tar v00rpm-dr.corp.domain.ru/dockerhub/docker-hello-world:$1
chown rundeck docker-hello-world.tar
cp /root/docker-hello-world.tar /home/rundeck/


#!/usr/bin/bash
ansible-playbook /home/rundeck/rundeck-job-playbook/rundeck-playbook.yml --extra-vars \"tag=$1\" --vault-password-file /home/rundeck/rundeck-job-playbook/vault.txt -vvvv
