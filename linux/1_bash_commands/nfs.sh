#NFS
#https://wiki.it-kb.ru/unix-linux/centos/linux-how-to-setup-nfs-server-with-share-and-nfs-client-in-centos-7-2
#Installing NFS
yum install nfs-utils nfs-utils-lib
systemctl enable rpcbind nfs-server
systemctl start rpcbind nfs-server

#optional- check NFS versions
rpcinfo -p localhost

#Создаём каталог под NFS-шару
mkdir -p /var/nfs
chmod -R 777 /var/nfs

#Создаём NFS-шару в файле /etc/exports:
cat /etc/exports
/var/nfs 10.1.1.0/24(rw,sync,no_root_squash,no_all_squash)


#Creating directory where mount NFS-disk(client)
mkdir /usr/share/tomcat/webapps/qsdc-files

#Mount NFS-disk
mount -t nfs 10.8.153.11:/qsdcfiles /usr/share/tomcat/webapps/qsdc-files

#add string to /etc/fstab for automount
10.8.153.11:/qsdcfiles /usr/share/tomcat/webapps/qsdc-files nfs rw,sync,hard,intr 0 0

#Check mount
mount -fav
---------------------------------------------------------------------------------------------
