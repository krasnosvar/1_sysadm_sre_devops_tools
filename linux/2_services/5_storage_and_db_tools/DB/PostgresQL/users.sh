#Users in PSQL
#list users
\du
#create user
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


sudo su - postgres
#create superuser
postgres=# create user elma with encrypted password 'PostgresStr0ngPassw0rd';
CREATE ROLE
postgres=# alter user elma with superuser;
ALTER ROLE
postgres=#

postgres=# alter user postgres_tst_user with password 'PostgresStr0ngPassw0rd#';
postgres=#  create user silvergate_db_user with encrypted password 'PostgresStr0ngPassw0rd';
postgres=# grant all privileges on database silvergate_db to silvergate_db_user;
postgres-# create database silvergate_db;
#or
sudo -u postgres createuser postgres_tst_user


# add db_user to superuser ( can create DB)
postgres=# ALTER USER silvergate_db_user WITH SUPERUSER;
#
postgres=# ALTER USER test_user WITH NOSUPERUSER;
