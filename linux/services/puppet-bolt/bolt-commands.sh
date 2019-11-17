bolt command run 'ls /home' --nodes rundeck
bolt command run 'uname -a' --nodes rundeck
#run command, translate ip of remote by echo
echo 10.8.181.164|bolt command run 'netstat -ntulp' --nodes -
#copy file to remote host
echo 10.8.181.164|bolt file upload ~/Downloads/Complete-NGINX-Cookbook-2019.pdf /home/krasnosvarov_dn --nodes -

bolt command run 'sudo service apcupsd start' --no-host-key-check --nodes 10.12.6.125, 10.12.6.126, 10.12.4.170
bolt command run 'sudo service apcupsd start' --no-host-key-check --user krasnosvarov_dn --password чччччч --nodes 10.12.6.125,10.12.6.126,10.12.4.170
