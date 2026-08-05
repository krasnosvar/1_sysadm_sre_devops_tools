#list all instlaled locales
locale -a

#set additional locale ru_RU.CP1251 to Ubuntu
apt install -y locales
cat /usr/share/i18n/SUPPORTED | grep ru_RU | grep CP1251
locale-gen ru_RU.CP1251
locale -a| grep -i "ru"
