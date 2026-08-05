#Ubuntu 20-04 Configs
/etc/postgresql/14/main/postgresql.conf
/etc/postgresql/14/main/pg_hba.conf


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


#pgbench
#create 15G test-db "banchmark"
pgbench -h localhost -U postgres -i -s 1000 benchmark
#check db
du -shc /var/lib/postgresql/12/main/base/17787/
15G	/var/lib/postgresql/12/main/base/17787/
15G	total
#test
pgbench -h localhost -U postgres -c 50 -j 2 -P 60 -T 600 benchmark


#check version
sudo -u postgres psql --version

#allow net connect
vi /var/lib/pgsql/14/data/postgresql.conf
listen_addresses = '*'

vi /var/lib/pgsql/14/data/pg_hba.conf
host  all  all 0.0.0.0/0 md5


# allow timing
# If you mean in psql, rather than some program you are writing, use \? for the help, and see:
# \timing [on|off]       toggle timing of commands (currently off)
\timing on


# INCREASING MAX PARALLEL WORKERS PER GATHER IN POSTGRES
# https://www.pgmustard.com/blog/max-parallel-workers-per-gather
SET max_parallel_workers_per_gather = 4;
SHOW max_parallel_workers_per_gather;

SET max_parallel_workers = 16;
SET max_worker_processes = 16;
select pg_reload_conf();
# and then check async execution with add "explain" before select
explain select * from test_db.test_table;
