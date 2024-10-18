#### Execute with python simultameously one command 10 times

* In example PSQL remote multiline-command, but it can be any shell command
```
psql -U root -p 5432 -h postgreas-host postgres << EOF
\\timing on
SELECT *
  FROM information_schema.role_table_grants 
 WHERE grantee = 'root';
SELECT pg_size_pretty( pg_database_size('postgres') );
EOF
```
