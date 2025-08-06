 Passwordless authorization on servers via ssh

To access servers without entering password, you need:

1.Install expect
apt install expect



2. create expect script,

(Replace PASSWORD with login password from which we connect),

I have two scripts, from admin_user and from domain account:
#!/usr/bin/expect -f
 
set password "PASSWORD"
set passwordroot "PASWORD"
set ipaddr [lindex $argv 0]
spawn ssh  -o StrictHostKeychecking=no admin_user@$ipaddr
match_max 100000
expect "*?assword:*"
send -- "$password\n"
expect "*?$"
send -- "sudo -i\n"
expect "Password:"
set timeout 0
send -- "$passwordroot\n"
interact

 

3. Add aliases to .bashrc
echo 'alias loc="expect /usr/git/work/scripts/ssh-auto-login/ssh-local.exp.sh"' >> ~/.bashrc
source ~/.bashrc

4. Now you can access servers with loc server command, get into sudo immediately:
loc rundeck
