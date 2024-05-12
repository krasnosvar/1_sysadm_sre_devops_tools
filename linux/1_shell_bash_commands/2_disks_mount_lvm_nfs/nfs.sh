#NFS
#https://wiki.it-kb.ru/unix-linux/centos/linux-how-to-setup-nfs-server-with-share-and-nfs-client-in-centos-7-2
#Installing NFS
#centos
sudo yum install nfs-utils nfs-utils-lib
#ubuntu
sudo apt-get install nfs-kernel-server nfs-common
#after config dir on server
sudo systemctl restart nfs-kernel-server
sudo ufw allow from client_ip to any port nfs
sudo ufw status

#for nfs3
systemctl enable rpcbind nfs-server --now
systemctl start rpcbind nfs-server

#optional- check NFS versions
rpcinfo -p localhost

#server
#create nfs dir
mkdir -p /var/nfs
chmod -R 777 /var/nfs
#add nfs-dir to /etc/exports:
cat /etc/exports
/var/nfs *(rw,sync,no_root_squash,no_all_squash)
exportfs -ar


#client
#check nfs mounts form client
showmount -e NFS_SERVER_IP
#Creating directory where mount NFS-disk(client)
mkdir /usr/share/tomcat/webapps/qsdc-files
#Mount NFS-disk
mount -t nfs 10.8.153.11:/qsdcfiles /usr/share/tomcat/webapps/qsdc-files
#add string to /etc/fstab for automount
10.8.153.11:/qsdcfiles /usr/share/tomcat/webapps/qsdc-files nfs rw,sync,hard,intr 0 0

#Check mount
mount -fav
---------------------------------------------------------------------------------------------
