#check version
sudo -u postgres psql --version

#Login as a test_user  user try to create a table on the Database.
psql -U test_user -h localhost -d test_db
#logis as postgres
sudo -u postgres psql

#create superuser
su postgres
psql -U postgres -c "CREATE USER root;" -c "ALTER USER root WITH SUPERUSER;"


#psql multiple commands
#https://www.postgresql.org/docs/current/app-psql.html
psql -U postgres -h <ip_addr> <database_name> << EOF
SELECT * FROM xyz_table;
SELECT * FROM abc_table;
EOF
#or
psql -U postgres \
-c "CREATE USER root;" \
-c "ALTER USER root WITH SUPERUSER;"


#copy (export) table to csv
# https://stackoverflow.com/questions/1120109/how-to-export-table-as-csv-with-headings-on-postgresql
psql -U user -d db_name -c "Copy (Select * From foo_table LIMIT 10) To STDOUT With CSV HEADER DELIMITER ',';" > foo_data.csv

# remote connect
psql postgresql://user:pass@host:1234/db


#check master-slave ( true- slave, false -master)
postgres=# SELECT pg_is_in_recovery();
 pg_is_in_recovery 
-------------------
 f
(1 row)

# check DB size
SELECT pg_size_pretty( pg_database_size('testdbname') );
