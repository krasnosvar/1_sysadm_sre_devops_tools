#APT
#all info about git package
apt show git
#show all installed packages
apt list --installed
yum list installed


#YUM
Удалить пакет  без удаления зависимостей.
Для этого сначала надо найти полное имя пакета: rpm -qa | grep "php55w-mysql"
В ответ получим что-то типа: php55w-mysql-5.5.33-1.w6.x86_64
Теперь, используя это имя, действуем: rpm -e --nodeps "php55w-mysql-5.5.33-1.w6.x86_64"
#Yum, шпаргалка
https://habr.com/ru/post/301292/
#delete all php but not "php-common"
yum remove *php* -- -php-common 
#How to know from which yum repository a package has been installed?
repoquery -i rh-mongodb*
yum info rh-mongodb34
rpm -qi rh-mongodb34
#yum history
#yum logs
yum history
yum history list
grep yum < ~/.bash_history
cat /var/log/yum.log | grep ambari-metrics-monitor
#list if installed( and version of rpm-package)
rpm -qa | grep yum
