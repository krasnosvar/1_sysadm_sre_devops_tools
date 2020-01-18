#CHPASSWD
#Изменение пароля одной строкой
echo root:password | chpasswd
cat file.txt| chpasswd
echo "Password123" | passwd root --stdin > /dev/null #не везде сработает



useradd
adduser
userdel
delser
