#оставить только строки, начинающиеся на Sep, в файлах /var/log/
for f in /var/log/*; do sed -i '/Sep.*/! d ' $f; done

#Найти и заменить
# word in files
find . -type f -exec sed -i 's/word/new_word/g' {} + 2> /dev/null
# ip
find /etc/ -type f -exec sed -i 's/10.8.152.62*/10.5.10.157/g' {} + 2> /dev/null
#change "/root" path to "/home/den" recursively in dir
find ~/.kube -type f -exec sed -i 's#/root#/home/den#g' {} + 2> /dev/null
# in helm chart dir (for example) recursively find and replace variable name in all files
# 'app-service-backend-v1' change to 'app2-service-backend-v2',
# for example in 
# cat ./templates/_helpers.tpl| grep app-service 
# {{- default (include "app-service-backend-v1.fullname" .) .Values.serviceAccount.name }}
sed -i 's/app-service-backend-v1/app2-service-backend-v2/g' $(find . -type f)


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

#change namespace
find .  -type f -exec sed -i 's/namespace: external-dev.*/namespace: default/g' {} + 2> /dev/null
#macos version
#brew install gnu-sed
find .  -type f -exec gsed -i 's/namespace: external-dev.*/namespace: default/g' {} + 2> /dev/null

#add "port80" in the end of every line in file
#https://stackoverflow.com/questions/15978504/add-text-at-the-end-of-each-line
# -i in-place (edit file in place)
# s substitution command
# /replacement_from_reg_exp/replacement_to_text/ statement
# $ matches the end of line (replacement_from_reg_exp)
# :80 text you want to add at the end of every line (replacement_to_text)
sed -i s/$/port80/ file1.txt

#update grup record
sed -i 's/GRUB_DEFAULT=saved/GRUB_DEFAULT=0/g' /etc/default/grub

#change all only after asterisk
#for example "default_pull_policy: Test" will be changed to "default_pull_policy: Never"
sed -i 's/default_pull_policy:.*/default_pull_policy: Never/g' k0s.yaml

#delete line exists pattern
sed '/pattern to match/d' file


#tr
#delete blank strings and make lower case to UPPER
cat ex6.txt | sed '/^$/d' | tr '[:lower:]' '[:upper:]'
