#Determine if filesystem or partition is mounted RO or RW via Bash Script?
grep "[[:space:]]ro[[:space:],]" /proc/mounts 



--------------------------------------------------------------------------------------------

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
--------------------------------------------------------------------------------------------
 ###########################################################################################
#LVM
#Discover partition to extend
ls /sys/class/scsi_disk/

#or

lsscsi -s
[1:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0        -
[2:0:0:0]    disk    VMware   Virtual disk     1.0   /dev/sda    536MB
[2:0:1:0]    disk    VMware   Virtual disk     1.0   /dev/sdb   53.6GB
[2:0:2:0]    disk    VMware   Virtual disk     1.0   /dev/sdc    107GB
[2:0:4:0]    disk    VMware   Virtual disk     1.0   /dev/sdd   1.87TB

#or
ls -ld /sys/block/sd*/device
lrwxrwxrwx 1 root root 0 Июл 18 17:42 /sys/block/sda/device -> ../../../2:0:0:0
lrwxrwxrwx 1 root root 0 Июл 18 17:42 /sys/block/sdb/device -> ../../../2:0:1:0
lrwxrwxrwx 1 root root 0 Июл 18 17:42 /sys/block/sdc/device -> ../../../2:0:2:0
lrwxrwxrwx 1 root root 0 Июл 18 17:42 /sys/block/sdd/device -> ../../../2:0:3:0


#Rescan disk
#Sending "- - -" to /sys/class/scsi_host/host[012]/scan is telling the SCSI host adapter 
#to look for new disks on every channel "(-)", every target "(-)", and every lun "(-)". - this is 
#the right thing to do if you add a new disk to the system while it's powered on.
#Sending a "1" to /sys/class/block/sdc/device/rescan is telling the SCSI block device to refresh 
#it's information about where it's ending boundary is (among other things) to give the kernel information 
#about it's updated size. - this is the right thing to do if you change the size of an existing disk while it's powered on.


echo '1' > /sys/class/scsi_disk/0\:0\:0\:0/device/rescan
#or
echo "1" > /sys/class/block/sdd/device/rescan

#See what partition(disk) to extent
parted -l

    Error: /dev/sdd: unrecognised disk label
    Model: VMware Virtual disk (scsi)
    Disk /dev/sdd: 1872GB
    Sector size (logical/physical): 512B/512B
    Partition Table: unknown
    Disk Flags:

pvs

  PV         VG      Fmt  Attr PSize    PFree
  /dev/sdb1  ol      lvm2 a--   <50,00g    0
  /dev/sdc   vg_app  lvm2 a--  <100,00g    0
  /dev/sdd   data_vg lvm2 a--    <1,41t    0

#Extend PV  
pvresize /dev/sdd

#Check again
pvs

  PV         VG      Fmt  Attr PSize    PFree
  /dev/sdb1  ol      lvm2 a--   <50,00g      0
  /dev/sdc   vg_app  lvm2 a--  <100,00g      0
  /dev/sdd   data_vg lvm2 a--     1,70t 300,00g

#check disk usadge
df -h
/dev/mapper/data_vg-rcdb_data_lv         1,4T  1,2T  145G  90% /u_ora

#Extend LV
lvextend -l +100%FREE /dev/mapper/data_vg-rcdb_data_lv

#Extend FileSystem
resize2fs /dev/mapper/data_vg-rcdb_data_lv
#or if it xfs
sudo yum –y install xfsprogs.x86_64
xfs_growfs FILESYSTEM

#Check again
df -h

/dev/mapper/data_vg-rcdb_data_lv         1,7T  1,2T  428G  74% /u_ora

#In short
ls /sys/class/scsi_disk/
echo '1' > /sys/class/scsi_disk/0\:0\:0\:0/device/rescan
pvresize /dev/sdd
lvextend -l +100%FREE /dev/data_vg/rcdb_data_lv
resize2fs /dev/data_vg/rcdb_data_lv
###########################################################################################

#Increasing without LVM
#https://computingforgeeks.com/resize-ext-and-xfs-root-partition-without-lvm/

<<<1>>>
[root@katello ~]# ls -ld /sys/block/sd*/device
lrwxrwxrwx 1 root root 0 авг 27 08:14 /sys/block/sda/device -> ../../../0:0:0:0
lrwxrwxrwx 1 root root 0 авг 27 08:14 /sys/block/sdb/device -> ../../../0:0:1:0
lrwxrwxrwx 1 root root 0 авг 27 08:14 /sys/block/sdd/device -> ../../../0:0:3:0
lrwxrwxrwx 1 root root 0 авг 27 08:14 /sys/block/sdf/device -> ../../../0:0:5:0

<<<2>>>
echo '1' > /sys/class/scsi_disk/0\:0\:5\:0/device/rescan

<<<3>>>
resize2fs /dev/sdf

<<<4>>>
df -Th


