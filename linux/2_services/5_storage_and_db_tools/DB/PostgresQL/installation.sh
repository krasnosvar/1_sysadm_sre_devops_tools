#install in ubuntu
# https://www.postgresql.org/download/linux/ubuntu/
# Create the file repository configuration:
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update the package lists:
sudo apt update

# Install the latest version of PostgreSQL.
# If you want a specific version, use 'postgresql-12' or similar instead of 'postgresql':
sudo apt -y install postgresql

sudo apt install postgresql-client postgresql postgresql-contrib libpq-dev




###### Install in Ubuntu version Postgres 9.5
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' && \
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add - && \
sudo apt update && \
sudo apt install -y postgresql-9.5 postgresql-contrib libpq-dev
#install postgres14 airgap
mkdir postgres14
cd postgres14/
apt install apt-rdepends
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
apt download $(apt-rdepends postgresql-14|grep -v debconf-2|grep -v "^ ")


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


# Install postgres 14 on CentOS 7
sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo yum repolist -y
yum list postgresql*
sudo yum install -y postgresql14-server postgresql14
rpm -qi postgresql14-server postgresql14
/usr/pgsql-14/bin/postgresql-14-setup initdb
sudo systemctl enable --now postgresql-14
systemctl start postgresql-14
systemctl status postgresql-14
systemctl enable postgresql-14

