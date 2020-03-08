# yum install -y php-fpm php-cli php-mysql php-gd php-ldap php-odbc php-pdo php-pecl-memcache php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap


#CentOS7
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y \
&& yum install https://rpms.remirepo.net/enterprise/remi-release-7.rpm -y \
&& yum install yum-utils -y \
&& yum-config-manager --enable remi-php74 -y \
&& yum update -y \
&& yum install php php-fpm php-pdo php-xml php-pear php-devel re2c gcc-c++ gcc -y



#RHEL7
#https://www.microsoft.com/en-us/sql-server/developer-get-started/php/rhel
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm  \
yum install https://rpms.remirepo.net/enterprise/remi-release-7.rpm \
subscription-manager repos --enable=rhel-7-server-optional-rpms \
yum install yum-utils \
yum-config-manager --enable remi-php74 \
yum update \
yum install php php-pdo php-xml php-pear php-devel re2c gcc-c++ gcc \

#RHEL8
sudo su
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
dnf install yum-utils
dnf module reset php
dnf module install php:remi-7.4
subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
dnf update
dnf install php-pdo php-pear php-devel
