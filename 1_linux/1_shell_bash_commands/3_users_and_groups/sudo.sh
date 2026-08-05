# what is sudo
# https://www.liquidweb.com/kb/how-to-set-up-and-manage-sudo-permissions/
# Sudo is a Linux program meant to allow a user to use root privileges for a limited timeframe to users and log root activity.  
# The basic thought is to give as few privileges as possible to a user while allowing  the user to accomplish a task. 
# The term "Sudo" means substitute user, and do. It is a program used for managing of user permission based on a system configuration file. 
# It allows users to run programs with the privileges of another user, by default, the superuser. 
# The program is supplied for most UNIX and Linux-based operating systems.

#Check if user sudoer on server(if no, output: User apache is not allowed to run sudo on v00graphictst.)
sudo -l -U krasnosvarov_dn

#sudoers with alias
User_Alias ADMINS = user1, user2
ADMINS ALL = NOPASSWD: ALL
root ALL=(ALL) ALL

#add user with sudo only in dir
sudo useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
#make user sudoer
sudo useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
#or oneliner
#if user exists, but no sudo
usr=den && echo "$usr ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$usr
#CREATE new user and sudo
usr=den && sudo useradd -s /bin/bash -mU $usr && echo "$usr ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$usr


#allow zabbix execute only systemctl stop-start httpd
[root@v00otrs01web ~]# cat /etc/sudoers.d/zabbixApache 
Cmnd_Alias APACHESVC=/usr/bin/systemctl stop httpd,/usr/bin/systemctl start httpd,/usr/bin/systemctl restart httpd,/usr/bin/systemctl reload httpd
zabbix ALL=(root) NOPASSWD:APACHESVC

#visudo set vim
sudo update-alternatives --config editor


#DAMAGED /ETC/SUDOERS — SYNTAX ERROR
#https://obu4alka.ru/resheno-povrezhdennyj-etc-sudoers-oshibka-v-sintaksise.html
#1. Open two ssh sessions to server (or work in two terminals or two tabs in terminal).
echo $$
#2. In second session start authentication agent using:
pkttyagent --process Your_PID
#3. Returning to first session, run:
pkexec visudo
#or
pkexec visudo -f /etc/sudoers.d/file
