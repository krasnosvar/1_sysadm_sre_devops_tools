# Copy a table from one database to another in Postgres
https://stackoverflow.com/questions/3195125/copy-a-table-from-one-database-to-another-in-postgres

# dump DB to file
pg_dump -U root -h pg-host.domain.local -p 5432 db_name -Fc -v -f dump_file.sql

#restore from file to db
pg_restore -v --host pg-host.domain.local -U root --dbname dxcore dump_file.sql
# or with additional flags
# -v, --verbose  verbose mode
# -c, --clean    clean (drop) database objects before recreating
# -O, --no-owner skip restoration of object ownership
pg_restore -v --clean --no-acl --no-owner --host pg-host.domain.local -U user_name --dbname test dump_file.sql



# Extract the table and pipe it directly to the target database:
pg_dump -t table_to_copy source_db | psql target_db
# Note: If the other database already has the table set up, you should use the -a flag to import data only, else you may see weird errors like "Out of memory":
pg_dump -a -t table_to_copy source_db | psql target_db


#dump from docker container
docker exec -i 90739991c205 /usr/bin/pg_dump -U root pd-database > postgres-backup.sql

#dump
docker exec -i pg_container_name /bin/bash -c "PGPASSWORD=pg_password pg_dump --username pg_username database_name" > /desired/path/on/your/machine/dump.sql
#restor
docker exec -i pg_container_name /bin/bash -c "PGPASSWORD=pg_password psql --username pg_username database_name" < /path/on/your/machine/dump.sql
