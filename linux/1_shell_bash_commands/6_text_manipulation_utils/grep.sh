#вывести конфиг без комментариев и пустых строк
grep ^[^#" "] /etc/zabbix/zabbix_agentd.conf
#or
grep ^[^\;] /etc/php/7.1/cli/php.ini
# or
cat /etc/httpd/conf/httpd.conf | grep -v '#'
grep -v -e '^#' /etc/conf
# or
grep -v -e '^#' -e'^$' /etc/config
#What if you have lines starting with some spaces or tabs other then # or ; character?
$ egrep -v "^$|^[[:space:]]*;" /etc/php/7.1/cli/php.ini 
#OR
$ egrep -v "^$|^[[:space:]]*#" /etc/postfix/main.cf

#remove duplicates
less sample.log | grep Linux| sort | uniq

#RECURSIVE
#искать в любом регистре по всей директории
grep -ri something ./*
#find "value" in all terraform files recursively(from searchin dir)
grep value $(find  . -name *.tf)
#search "gitlab" only in files with *.tf or *.sh extenssion
grep -ri "gitlab" --include \*.{tf,sh} /home/den/git_projects/terraform_scripts/

#если нужно перебрать большое кол-во файлов и при выводе команды grep -ri "10.8.37.147" /var/log выходит ошибка 
#"grep: memory exhaust" (память заполнена, это потому что grep перебирает все сразу, забивая ОЗУ) можно попробовать 
#выполнить grep в связке с командой find, перебирая каждый файл по очереди:
find /var/log -type f -exec grep -H "10.8.37.147" "{}" \;

#Find all logs more than 1G
ls -Rlahi /var/log | grep -E "[0-9]G " 2>/dev/null

#искать в строке несколько слов(если порядок поменять, не найдет):
cat /etc/os-release | grep -E "Oracle.*Linux.*7"

#find and show only last names in directory path
#cut command:
#-d(delimiter) "/"- slash, -f 7 - seventh stolbetsc(last in output path)
#https://www.geeksforgeeks.org/cut-command-linux-examples/
grep "/suag" ansible/suag_update/*|cut -d "/" -f 7

#AFTER - BEFORE
#show searching pattern and five strings before it
grep -B5 makestep /etc/chrony.conf 
ps fax | grep -B5 dd
#show searching pattern and one string below(down) it
cat /etc/foreman-maintain/foreman-maintain-hammer.yml |grep -A 1 admin

#grep OR OR
#поиск ИЛИ mysql ИЛИ mariadb и вывести результат в файл output.log
 grep -rE "mysql|mariadb" > output.log
#grep AND 'Red' AND 'Cent'
grep 'Red\|Cent' list_vms.txt
#grep server name starts with "v00" OR "s00" in string starts with "DATABASE_NAME="
cat /var/www/app/.env.config| grep 'DATABASE_BASE=' |grep -E -o "s00[A-Za-z0-9._%+-]+|v00[A-Za-z0-9._%+-]+"

#Find out current disk name
sudo fdisk -l | grep '^Disk /dev/sd[a-z]'

#Грепнуть e-mail регулярка
#https://www.shellhacks.com/ru/regex-find-email-addresses-file-grep/
"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b"
grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" file.txt

# show only searched word
lscpu| grep -o aes
#grep ONLY "grepping" pattern "ip_address_balancer_1"
cat output| grep -o ip_address_balancer_1
#find IPs- regex for ip-addresses
terraform refresh | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'
