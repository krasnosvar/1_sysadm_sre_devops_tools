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



#Ubuntu 20-04 Configs
/etc/postgresql/14/main/postgresql.conf
/etc/postgresql/14/main/pg_hba.conf
