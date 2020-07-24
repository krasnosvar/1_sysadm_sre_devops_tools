#https://mariadb.com/resources/blog/installing-mariadb-10-on-centos-7-rhel-7/
#https://mariadb.com/resources/blog/how-to-install-mariadb-on-rhel8-centos8/
#https://mariadb.com/kb/en/yum/
#mariadb in centos
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
yum install -y mariadb mariadb-server

#main commands
#show all databases
SHOW DATABASES;
#use database test
use test;
#show all in test
SELECT * FROM test;


#install db for wordpress
$ mysql -u adminusername -p
mysql> CREATE DATABASE wordpress;
grant all privileges on new_wp.* to wpuser@localhost identified by 'myp@Ssw0Rd';
FLUSH PRIVILEGES;
EXIT
