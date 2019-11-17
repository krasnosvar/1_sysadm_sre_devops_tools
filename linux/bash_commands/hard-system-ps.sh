=======
#Common administrative commands in Red Hat Enterprise Linux 5, 6, 7, and 8
https://access.redhat.com/articles/1189123


#Show RAM type
sudo lshw -short -C memory
---------------------------------------------------------------------------------------------

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
#генерация самоподписного сертификата
openssl genrsa -out private.key 2048 && openssl req -new -subj '/CN=localhost/O=domain/C=RU/ST=KRD/L=Krasnodar' -key private.key -out cert.csr && openssl x509 -req -in cert.csr -signkey private.key -out cert.crt -days 3650 && cat cert.crt > my.pem && cat private.key >> my.pem

#Random password generation
openssl rand -base64 12

#Get cert CA
openssl s_client -showcerts -servername server -connect server:443 > cacert.pem
---------------------------------------------------------------------------------------------

#проверить наличие у этого сервера аттрибутов

#команды(скриптом, лежит в scripts):
ldapsearch -h adldap.corp.domain.ru -LLL -D "krasnosvarov_dn@corp.domain.ru" -W -b "dc=corp,dc=domain,dc=ru" -s sub "(cn=krasnosvarov_dn)" loginShell unixHomeDirectory
ldapsearch -h adldap.corp.domain.ru -LLL -D "krasnosvarov_dn@corp.domain.ru" -W -b "dc=corp,dc=domain,dc=ru" -s sub "(cn=V00SOLVOORA-TST)" userAccountControl sAMAccountName dNSHostName userPrincipalName servicePrincipalName
---------------------------------------------------------------------------------------------

#NFS
#https://wiki.it-kb.ru/unix-linux/centos/linux-how-to-setup-nfs-server-with-share-and-nfs-client-in-centos-7-2
#Installing NFS
yum install nfs-utils nfs-utils-lib
systemctl enable rpcbind nfs-server
systemctl start rpcbind nfs-server

#optional- check NFS versions

#Creating directory where mount NFS-disk(client)
mkdir /usr/share/tomcat/webapps/qsdc-files

#Mount NFS-disk
mount -t nfs 10.8.153.11:/qsdcfiles /usr/share/tomcat/webapps/qsdc-files

#add string to /etc/fstab for automount
10.8.153.11:/qsdcfiles /usr/share/tomcat/webapps/qsdc-files nfs rw,sync,hard,intr 0 0

#Check mount
mount -fav
---------------------------------------------------------------------------------------------

#NTP Ubuntu 18
apt install ntp ntpdate -y
sudo timedatectl set-ntp off 
echo -e "10.8.13.11      domain-ntp-server\n10.8.13.12      domain2-ntp-server" >> /etc/hosts
echo -e "server domain-ntp-server iburst" >> /etc/ntp.conf
sudo systemctl restart ntp
ntpq -p

#or
apt install ntp ntpdate -y
sudo timedatectl set-ntp off
echo -e " server 10.8.13.11\nserver 10.8.13.12" >> /etc/ntp.conf
sudo systemctl restart ntp
ntpq -p
---------------------------------------------------------------------------------------------

#ubuntu запретить открытие Activities через Super(Win key)
dconf write /org/gnome/mutter/overlay-key "'Alt_R'"

#Check if user sudoer on server(if no, output: User apache is not allowed to run sudo on v00graphictst.)
sudo -l -U krasnosvarov_dn

---------------------------------------------------------------------------------------------
#Доступ сотруднику 
#Добавить учетку пользователя в файл
vi /etc/opt/quest/vas/users.allow
