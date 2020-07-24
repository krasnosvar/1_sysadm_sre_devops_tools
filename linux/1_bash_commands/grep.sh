#искать в строке несколько слов(если порядок поменять, не найдет):
cat /etc/os-release | grep -E "Oracle.*Linux.*7"

#искать в любом регистре по всей директории
grep -ri something ./*

#если нужно перебрать большое кол-во файлов и при выводе команды grep -ri "10.8.37.147" /var/log выходит ошибка 
#"grep: memory exhaust" (память заполнена, это потому что grep перебирает все сразу, забивая ОЗУ) можно попробовать 
#выполнить grep в связке с командой find, перебирая каждый файл по очереди:
find /var/log -type f -exec grep -H "10.8.37.147" "{}" \;

#Вывод конфига(ну или любого файла) без закоментированных строк
#grep -v '^#' /etc/zabbix/zabbix_agentd.conf | sed '/^$/d'
cat /etc/httpd/conf/httpd.conf | grep -v '#'
grep -v -e '^#' /etc/conf

#Вывод без комментариев и пустых строк
grep -v -e '^#' -e'^$' /etc/config

#Find all logs more than 1G
 ls -Rlahi /var/log | grep -E "[0-9]G " 2>/dev/null

#find and show only last names in directory path
#cut command:
#-d(delimiter) "/"- slash, -f 7 - seventh stolbetsc(last in output path)
#https://www.geeksforgeeks.org/cut-command-linux-examples/
grep "/suag" ansible/suag_update/*|cut -d "/" -f 7


#show searching pattern and five strings before it
grep -B5 makestep /etc/chrony.conf 
ps fax | grep -B5 dd
#show searching pattern and one string below(down) it
cat /etc/foreman-maintain/foreman-maintain-hammer.yml |grep -A 1 admin

#Find out current disk name
sudo fdisk -l | grep '^Disk /dev/sd[a-z]'

#grep OR OR
#поиск ИЛИ mysql ИЛИ mariadb и вывести результат в файл output.log
 grep -rE "mysql|mariadb" > output.log
#grep AND 'Red' AND 'Cent'
grep 'Red\|Cent' list_vms.txt

#Грепнуть e-mail регулярка
https://www.shellhacks.com/ru/regex-find-email-addresses-file-grep/


#find IPs- regex for ip-addresses
terraform refresh | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'
