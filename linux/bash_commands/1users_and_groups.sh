#CHPASSWD
#Изменение пароля одной строкой
echo root:password | chpasswd
cat file.txt| chpasswd
echo "Password123" | passwd root --stdin > /dev/null #не везде сработает
#generate password
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '' #generate random pass


useradd
adduser
userdel
deluser
