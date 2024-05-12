#use ansible with PASSWORD variable
ansible-playbook -i /usr/git/work/ansible/test-role/hosts  /usr/git/work/ansible/test-role/test-role.yml --extra-vars='ansible_ssh_pass=$PASSWORD  ansible_become_pass=$PASSWORD' -v

# path to file in playbook(no need to write all path to file, use variable "role_path")
# "{{ role_path }}/templates/keepalived.conf.j2"

# ansible loop for hostname(in template, for example)
# writes string with "facts": server "hostname" "ip-address":443 check
# {% for backend in groups['test'] %}
# server {{ ansible_hostname }} {{ ansible_ens192['ipv4']['address'] }}:443 check
# {% endfor %}

#check ssh connection
ansible all -u den -i inventory/inventory.cfg -m ping

#create role sample
ansible-galaxy init test-role

#execute task in playbook only in "fetch" group
    - name: Execute  command
      hosts: fetch
      shell: "whoami"
      when: inventory_hostname in groups['fetch']
#or
    - name: Copy config to server-group-1 
      delegate_to: "{{item}}"
      loop: "{{groups['group1']}}"
      template:
        src: "{{main_dir}}/config_sample/filebeat.yml.j2"
        dest: /etc/filebeat/filebeat.yml

#stdout in human readable lines
    - name: Do command
      shell: 'filebeat test config && filebeat test output'
      register: out

    - debug: var=out.stdout_lines
    - debug: var=out.stderr_lines


#show ansible variable in hosts
ansible -i hosts -l web-tst -m debug -a "var=ansible_ssh_host" all -u root -b --extra-vars="ansible_ssh_pass=$PASS ansible_become_pass=$PASS" -v
