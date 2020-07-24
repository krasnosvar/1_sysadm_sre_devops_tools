#оставить только строки, начинающиеся на Sep, в файлах /var/log/
for f in /var/log/*; do sed -i '/Sep.*/! d ' $f; done

#Найти и заменить 
find /etc/ -type f -exec sed -i 's/10.8.152.62*/10.5.10.157/g' {} + 2> /dev/null

#Вывод конфига(ну или любого файла) без закоментированных строк
grep -v '^#' /etc/zabbix/zabbix_agentd.conf | sed '/^$/d'
grep -v -e '^#' /etc/conf

#Вывод без комментариев и пустых строк
grep -v -e '^#' -e'^$' /etc/config

#Show 9 line of etc passwd
sed -n 9p /etc/passwd

#delete line(second here) in file
sed -i -e '2d' ~/myfile

#Delete 2, 20-25 lines in file
sed -i -e ‘2d;20,25d’ ~/myfile

#enable network autostart on boot
sed -i -e ‘s@^ONBOOT=”no@ONBOOT=”yes@’ /etc/sysconfig/network-scripts/ifcfg-enp0s3

#delete blank strings
sed -i '/^[[:space:]]*$/d' file.txt

#change part URL(in Nexus repo-file, as axample)
sed -i 's~https://download.docker.com~https://repo.corp.ru/repository/docker~g' user.html

#require tty
"sed -i -e 's/Defaults    requiretty.*/ #Defaults    requiretty/g' /etc/sudoers"

