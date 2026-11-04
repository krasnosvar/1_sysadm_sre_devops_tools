#list db and tables
#ist all databases
list or \l
#list all tables in the current database using your search_path
\dt
#list all tables in the current database regardless your search_path
\dt *.
#  lists all schemas excluding system's in the current database:
\dn
#connect to database
\c database_name
#show tables in database
select * from table_name;
#insert values in table
INSERT INTO auth_user (password, username, is_superuser) VALUES ('test', 'test', TRUE);


# Copy a table from one database to another in Postgres
https://stackoverflow.com/questions/3195125/copy-a-table-from-one-database-to-another-in-postgres
# Extract the table and pipe it directly to the target database:
pg_dump -t table_to_copy source_db | psql target_db
# Note: If the other database already has the table set up, you should use the -a flag to import data only, else you may see weird errors like "Out of memory":
pg_dump -a -t table_to_copy source_db | psql target_db



#create db, user-admin for it and connect to db
CREATE DATABASE my_db;
CREATE USER my_db_admin WITH ENCRYPTED PASSWORD 'my_db_admin';
GRANT ALL PRIVILEGES ON DATABASE my_db TO my_db_admin;
\c my_db

#create table and insert data into it
CREATE TABLE users(
    user_id SERIAL PRIMARY KEY NOT NULL,
    username varchar(50) NOT NULL,
    email varchar(50) NOT NULL,
    mobile_phone varchar(12) NOT NULL,
    firstname TEXT NOT NULL,
    lastname TEXT NOT NULL,
    city  TEXT,
    is_curator boolean NOT NULL,
    record_date timestamp NOT NULL DEFAULT now()
    );

INSERT INTO users (user_id,	username,	email,	mobile_phone,	firstname,	lastname,	city,	is_curator)
VALUES
  (1, 'max', 'Max456@mail.ru', '+791110478', 'Max', 'Vasikov', NULL, false ),
  (2, 'kisa', 'Kisa123@mail.ru', '+791124059', 'Maya', 'Ivanova', 'Tver', false ),
  (3, 'grenbal', 'maike234@corp.com', '+791124258', 'Mike', 'Azovsky', 'Town', true );


#delete (drop) table
DROP TABLE courses;


#copy (export) table to csv
# https://stackoverflow.com/questions/1120109/how-to-export-table-as-csv-with-headings-on-postgresql
psql -U user -d db_name -c "Copy (Select * From foo_table LIMIT 10) To STDOUT With CSV HEADER DELIMITER ',';" > foo_data.csv


# How to Duplicate a Table in PostgreSQL
# https://popsql.com/learn-sql/postgresql/how-to-duplicate-a-table-in-postgresql
create table dupe_users as (select * from users);
# -- The `with no data` here means structure only, no actual rows
create table dupe_users as (select * from users) with no data;
