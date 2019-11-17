#ansible-playbook /usr/git/work/ansible/transfer-file/transfer.yml --vault-password-file /usr/git/work/ansible/rundeck-job-playbook/vault.txt -v

echo -e "[transfer]\n$1" >> /home/den/git/work/ansible/transfer-file/hosts
ansible-playbook -i /home/den/git/work/ansible/transfer-file/hosts /home/den/git/work/ansible/transfer-file/transfer.yml --vault-password-file /home/den/Documents/ansible_no_git/vault.txt -v
