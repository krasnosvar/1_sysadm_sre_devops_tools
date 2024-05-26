#APT
#List Installed Repositories In Ubuntu
sudo grep -rhE ^deb /etc/apt/sources.list*
#all info about git package
apt show git
#show all installed packages
apt list --installed
apt list --installed | grep wine
#list installed kernels
apt list --installed | egrep -i --color 'linux-image|linux-headers'
#upgrade only one package
apt-get --only-upgrade install tomcat9
#Create a List of all Installed Packages
sudo dpkg-query -f '${binary:Package}\n' -W > packages_list.txt
#Now that you have the list, you can install the same packages on your new server with:
sudo xargs -a packages_list.txt apt install
#add apt repo
sudo add-apt-repository 'deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main'
#install specific version
apt list helmfile -a
sudo apt install helmfile=0.163.1-1~ops2deb


#if ERROR in /var/log/unattended-upgrades/unattended-upgrades.log
#PACKAGE is kept back because a related package is kept back or due to local apt_preferences(5)
#do:
sudo apt-get --with-new-pkgs upgrade
sudo apt-get dist-upgrade
#The following signatures were invalid: EXPKEYSIG
# https://askubuntu.com/questions/1129025/invalid-signatures-expkeysig
wget -nv http://download.opensuse.org/repositories/systemsmanagement:/terraform/Ubuntu_20.04/Release.key -O Release.key
sudo apt-key add - < Release.key
sudo apt-get update


#download debs for airgap install
apt download $(apt-rdepends {package}|grep -v "^ ")
#install postgres14 airgap
mkdir postgres14
cd postgres14/
apt install apt-rdepends
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
apt download $(apt-rdepends postgresql-14|grep -v debconf-2|grep -v "^ ")


#SNAP
#update snaps
sudo snap refresh
#Install Snap from file
#https://www.ubuntubuzz.com/2019/01/install-snap-from-file-offline-and-parallel.html
snap install --dangerous vlc1.snap



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
yum list installed
rpm -qa | grep yum
#How do I exclude kernel or other packages from getting updated in Red Hat Enterprise Linux while updating system via yum?
#https://access.redhat.com/solutions/10185
yum update --exclude=kernel*
#
yum update --exclude=python2-qpid-proton* --exclude=qpid-proton-c*
# show all versions of packet in repo
yum list docker-ce --showduplicates
