echo -e "[test]\n$RD_OPTION_IP_ADDRESS" > /etc/ansible/hosts
ansible-playbook /etc/ansible/roles/add_host_to-katello/add_host_foreman.yml -vvv