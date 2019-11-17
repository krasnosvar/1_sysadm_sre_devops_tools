 Беспарольная авторизация на серверах через ssh

Чтобы попадать на сервера без ввода пароля, надо:

1.Установить expect
apt install expect

 

2. создать expect-скрипт,

(PASSWORD заменить на пароль логина, от которого подключаемся),

у меня два скрипта, от local и от доменной учетки:
#!/usr/bin/expect -f
 
set password "PASSWORD"
set passwordroot "PASWORD"
set ipaddr [lindex $argv 0]
spawn ssh  -o StrictHostKeychecking=no local@$ipaddr
match_max 100000
expect "*?assword:*"
send -- "$password\n"
expect "*?$"
send -- "sudo -i\n"
expect "Password:"
set timeout 0
send -- "$passwordroot\n"
interact

 

3. Прописать алиасы в .bashrc
echo 'alias loc="expect /usr/git/work/scripts/ssh-auto-login/ssh-local.exp.sh"' >> ~/.bashrc
source ~/.bashrc

4. Теперь можно заходить на сервера командой loc server, попадаем сразу в sudo:
loc rundeck

