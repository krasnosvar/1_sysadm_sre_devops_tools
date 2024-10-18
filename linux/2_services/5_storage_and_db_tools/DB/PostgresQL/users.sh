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


#Users and groups
# -- grant multiple roles to user
grant role1, role2, role3 to user_login;



# check user roles ( from inside postgres)
WITH RECURSIVE cte AS (
   SELECT oid FROM pg_roles WHERE rolname = 'user_login'

   UNION ALL
   SELECT m.roleid
   FROM   cte
   JOIN   pg_auth_members m ON m.member = cte.oid
   )
SELECT oid, oid::regrole::text AS rolename FROM cte;
# output
   oid   |          rolename           
---------+-----------------------------
 1118438 | user_login
  711146 | role1
  711153 | role2
  711155 | role3
  711156 | role4


# check user privileges
# https://stackoverflow.com/questions/40759177/postgresql-show-all-the-privileges-for-a-concrete-user
# Table permissions:
SELECT *
  FROM information_schema.role_table_grants 
 WHERE grantee = 'YOUR_USER';

# Ownership:
 SELECT *
  FROM pg_tables 
 WHERE tableowner = 'YOUR_USER';

Schema permissions:
       SELECT r.usename AS grantor,
             e.usename AS grantee,
             nspname,
             privilege_type,
             is_grantable
        FROM pg_namespace
JOIN LATERAL (SELECT *
                FROM aclexplode(nspacl) AS x) a
          ON true
        JOIN pg_user e
          ON a.grantee = e.usesysid
        JOIN pg_user r
          ON a.grantor = r.usesysid 
       WHERE e.usename = 'YOUR_USER';


# grant all to table
GRANT ALL PRIVILEGES ON TABLE test_activ TO test_db_user;
