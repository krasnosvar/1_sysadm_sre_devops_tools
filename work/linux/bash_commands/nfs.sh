#NFS
#https://wiki.it-kb.ru/unix-linux/centos/linux-how-to-setup-nfs-server-with-share-and-nfs-client-in-centos-7-2
#Installing NFS
yum install nfs-utils nfs-utils-lib
systemctl enable rpcbind nfs-server
systemctl start rpcbind nfs-server

#optional- check NFS versions

#Creating directory where mount NFS-disk(client)
mkdir /usr/share/tomcat/webapps/qsdc-files

#Mount NFS-disk
mount -t nfs 10.8.153.11:/qsdcfiles /usr/share/tomcat/webapps/qsdc-files

#add string to /etc/fstab for automount
10.8.153.11:/qsdcfiles /usr/share/tomcat/webapps/qsdc-files nfs rw,sync,hard,intr 0 0

#Check mount
mount -fav
---------------------------------------------------------------------------------------------
