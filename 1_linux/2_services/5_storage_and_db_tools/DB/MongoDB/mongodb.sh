#check connection to remote MongoDB
mongo -u pulp -p Password server.ru/pulp_database
#Print a list of all databases on the server.


#add mongodb repo to centos7-8
cat <<EOF > /etc/yum.repos.d/mongodb-org-4.2.repo
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc
EOF

#install mongodb on centos7-8
sudo yum install -y mongodb-org
sudo systemctl start mongod

