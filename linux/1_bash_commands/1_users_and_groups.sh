#CHPASSWD
#Изменение пароля одной строкой
echo root:password | chpasswd
cat file.txt| chpasswd
echo "Password123" | passwd root --stdin > /dev/null #не везде сработает
#generate password
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '' #generate random pass


#useradd
#create system user
useradd -r tomcat --shell /bin/false
#create user with: home dir, bash shell, and same group as name 
useradd -mU user --shell /bin/bash

adduser
userdel
deluser


#delete user
#-r remove home dir
#-f delete files in "home" even not user permissions
userdel -r -f test_user
