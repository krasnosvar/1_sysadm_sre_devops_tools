#execute local script on server through ssh
ssh root@192.168.1.1 'bash -s' < script.sh

ssh-keygen -t rsa

ssh-copy-id -i .ssh/id_rsa.pub den@192.168.43.215

#mikrotik ssh key add to routeros
scp ~/.ssh/id_rsa.pub admin@192.168.88.1:/
user ssh-keys import user=admin public-key-file=id_rsa.pub

sudo vi /etc/ssh/ssh_config
### Алиасы для быстрого подключения ###
Host userv
HostName 192.168.43.100 
User den
Port 22
