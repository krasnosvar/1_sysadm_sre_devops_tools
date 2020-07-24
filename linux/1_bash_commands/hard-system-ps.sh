=======
#Common administrative commands in Red Hat Enterprise Linux 5, 6, 7, and 8
https://access.redhat.com/articles/1189123


#Show RAM type
sudo lshw -short -C memory
---------------------------------------------------------------------------------------------
#show MB manufacturer and model
sudo dmidecode -t 2


#ubuntu запретить открытие Activities через Super(Win key)
dconf write /org/gnome/mutter/overlay-key "'Alt_R'"

---------------------------------------------------------------------------------------------
#ubuntu 18.04 крышка ноута закрыта но ноут не выключается
vi /etc/systemd/logind.conf
#раскомментировать:
#HandleLidSwitch=ignore
=======
#убить процессы пользователя(например, для его удаления)
ps aux | awk '/^toor/ {print $2}' | xargs kill -9
---------------------------------------------------------------------------------------------

#execute local script on server through ssh
ssh root@192.168.1.1 'bash -s' < script.sh
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------

#проверить наличие у этого сервера аттрибутов

#команды(скриптом, лежит в scripts):
ldapsearch -h adldap.corp.domain.ru -LLL -D "krasnosvarov_dn@corp.domain.ru" -W -b "dc=corp,dc=domain,dc=ru" -s sub "(cn=krasnosvarov_dn)" loginShell unixHomeDirectory
ldapsearch -h adldap.corp.domain.ru -LLL -D "krasnosvarov_dn@corp.domain.ru" -W -b "dc=corp,dc=domain,dc=ru" -s sub "(cn=V00SOLVOORA-TST)" userAccountControl sAMAccountName dNSHostName userPrincipalName servicePrincipalName
---------------------------------------------------------------------------------------------




