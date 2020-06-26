#install in ubuntu
sudo apt-get update
sudo apt-get install libpq-dev postgresql postgresql-contrib

###### Install in Ubuntu version Postgres 9.5
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' && \
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add - && \
sudo apt update && \
sudo apt install -y postgresql-9.5 postgresql-contrib libpq-dev

#install on centos8
#https://computingforgeeks.com/how-to-install-postgresql-11-on-centos-rhel-8/
sudo dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
rpm -qi pgdg-redhat-repo #check repo 
sudo dnf module disable postgresql #Disable postgresql module.
sudo dnf clean all #Then clean yum cache and install PostgreSQL 11 on CentOS 8 / RHEL 8
sudo dnf -y install postgresql11-server postgresql11 postgresql-libs
#After installation, database initialization is required before service can be started
sudo /usr/pgsql-11/bin/postgresql-11-setup initdb
sudo systemctl enable --now postgresql-11
sudo systemctl status postgresql-11
/var/lib/pgsql/11/data/postgresql.conf
#Set PostgreSQL admin user
sudo su - postgres 
psql -c "alter user postgres with password 'StrongPassword'"
#Create a test user and database
[postgres@rhel8 ~]$ psql
psql (11.5)
Type "help" for help.

#Users in PSQL
postgres-# createuser test_user
postgres-# alter user test_user with password 'MyDBpassword';
postgres-# createdb test_db -O test_user
postgres-# grant all privileges on database test_db to test_user;
GRANT
#Login as a test_user  user try to create a table on the Database.
psql -U test_user -h localhost -d test_db
#logis as postgres
sudo -u postgres psql
#set passwd for user postgres
ALTER USER postgres PASSWORD '12345';

#see in postgres data dir
postgres=# show data_directory;
       data_directory        
-----------------------------
 /var/lib/postgresql/12/main
(1 row)

#see what filename for DB
postgres=# SELECT oid,datname from pg_database;
  oid  |       datname       
-------+---------------------
 13427 | postgres
 16385 | mastodon_production
     1 | template1
 13426 | template0
 17787 | benchmark
(5 rows)



#list db and tables
#ist all databases
list or \l
#list all tables in the current database using your search_path
\dt
#list all tables in the current database regardless your search_path
\dt *.
#connect to database
\c database_name
#show tables in database
select * from tanle_name;
#insert values in table
INSERT INTO auth_user (password, username, is_superuser) VALUES ('test', 'test', TRUE);

#pgbench
#create 15G test-db "banchmark"
pgbench -h localhost -U postgres -i -s 1000 benchmark
#check db
du -shc /var/lib/postgresql/12/main/base/17787/
15G	/var/lib/postgresql/12/main/base/17787/
15G	total
#test
pgbench -h localhost -U postgres -c 50 -j 2 -P 60 -T 600 benchmark
