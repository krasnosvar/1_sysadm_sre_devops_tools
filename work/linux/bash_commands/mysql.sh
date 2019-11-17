yum install -y mariadb mariadb-server net-tools

#install db for wordpress
$ mysql -u adminusername -p
mysql> CREATE DATABASE wordpress;
grant all privileges on new_wp.* to wpuser@localhost identified by 'myp@Ssw0Rd';
FLUSH PRIVILEGES;
EXIT
