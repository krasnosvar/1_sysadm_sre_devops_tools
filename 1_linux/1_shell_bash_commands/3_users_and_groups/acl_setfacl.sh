#TASK: add read permissions to group "GROUPNAME" to directory "/var/log/nginx"
#1.
#check if user-group "GROUPNAME" presents on server. Local or LDAP no matter
#https://www.cyberciti.biz/faq/linux-check-existing-groups-users/
getent group GROUPNAME
#2.
#Check if acl ON( should return: "Default mount options:    user_xattr acl" )
#https://wiki.archlinux.org/index.php/Access_Control_Lists_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
sudo tune2fs -l /dev/sda2 | grep "Default mount options:"
#3.
#set acl to user "den" 
setfacl -m "u:den:rwx" /home/Ftp/test
#set acl read rights to group(for reading must be "r-x", just "r" not working)
setfacl -R -m g:GROUPNAME:r-x /var/log/nginx
#4.
#check acl rules
getfacl /var/log/nginx

#remove rules
setfacl -b /nfs_data

#add default rules
setfacl -m d:o:rwx /nfs_data
