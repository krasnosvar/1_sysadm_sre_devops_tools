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
