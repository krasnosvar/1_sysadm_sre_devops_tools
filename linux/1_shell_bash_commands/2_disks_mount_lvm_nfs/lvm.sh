#LVM

#create LVM
#add disks to lvm
pvcreate /dev/sdb /dev/sdc /dev/sdd
#create volume-group from physical disks
vgcreate vg00 /dev/sdb /dev/sdc
#create logical-volume from vg
lvcreate -n vol_projects -L 10G vg00
lvcreate -n vol_backups -l 100%FREE vg00



#extend resized partition( or disk) in VM
#Discover partition to extend
ls /sys/class/scsi_disk/
#or
lsscsi -s
#or
ls -ld /sys/block/sd*/device
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
pvs
#Extend PV  
pvresize /dev/sdd
#Check again
pvs
#check disk usadge
df -h
#Extend LV
lvextend -l +100%FREE /dev/mapper/data_vg-rcdb_data_lv
#Extend FileSystem
resize2fs /dev/mapper/data_vg-rcdb_data_lv
#or if it xfs
sudo yum –y install xfsprogs.x86_64
xfs_growfs FILESYSTEM
#Check again
df -h


#In short
ls /sys/class/scsi_disk/
echo '1' > /sys/class/scsi_disk/0\:0\:0\:0/device/rescan
pvresize /dev/sdd
lvextend -l +100%FREE /dev/data_vg/rcdb_data_lv -r
resize2fs /dev/data_vg/rcdb_data_lv

#если надо уменьшить до определенного размера, например с 200Г до 100Г
resize2fs /dev/data_vg/rcdb_data_lv 100G
###########################################################################################
#xfs можно только увеличить
xfs_growfs [options] mount-point

    -d: Expand the data section of the file system to the maximum size of the underlying device.
    -D [size]: Specify the size to expand the data section of the file system. The [size] argument is expressed in the number of file system blocks.
    -L [size]: Specify the new size of the log area. This does not expand the size, but specifies the new size of the log area. Therefore, this option can be used to shrink the size of the log area. You cannot shrink the size of the data section of the file system.
    -m [maxpct]: Specify the new value for the maximum percentage of space in the file system that can be allocated as inodes. With the mkfs.xfs command, this option is specified with the –i maxpct=[value] option.


###########################################################################################
#Задача — уменьшить ubuntu--vg-root, а на освободившееся место — увеличить ubuntu--vg-home.
#Проверяем целостность ФС:
e2fsck -f /dev/ubuntu-vg/root
#Уменьшаем размер файловой системы до 5 GB
resize2fs /dev/ubuntu-vg/root 5G
#Уменьшаем размер тома до 5gb:
lvreduce -L 5G /dev/ubuntu-vg/root
#Проверяем
lsblk /dev/sda5
#С помощью lvextend — увеличиваем размер ubuntu--vg-home на 5G:
lvextend -L +5G /dev/ubuntu-vg/home
#Проверяем ФС:
e2fsck -f /dev/ubuntu-vg/home
#И выполняем resize. Не укзываем размер, что бы занять 100% свободного места:
resize2fs -p /dev/ubuntu-vg/home


###########################################################################################
#Добавить целый диск в LVM
#check WWN(LUN)
ls -la /dev/disk/by-id/
#If you are using a whole disk device for your physical volume, the disk must have no partition table.
#You can remove an existing partition table by zeroing the first sector with the following command:
dd if=/dev/zero of=PhysicalVolume bs=512 count=1
#Create PV
pvcreate /dev/sdd
#Extend exiting VG
vgextend vg_data /dev/sdd
#Check max size and extend LV on it
vgs
lvextend -L 544G /dev/vg_data/lv_data -r
#or
lvextend -l +100%FREE /dev/vg_data/lv_data -r


###########################################################################################
#Удалить один диск из LVM. Остается диск на 33Гб. Занимаемого места 5Г. 
#То есть уменьшаем размер LV до 30Г(потом увеличим на весь размер диска).
#Переносим данные с отключаемого диска и удаляем его из LVM.
#размонтировать раздел
umount /mnt/data/
#уменьшить размер файловой системы
e2fsck -f /dev/vg_data/lv_data
resize2fs /dev/vg_data/lv_data 30G
#уменьшить размер LV
lvreduce --size 30G /dev/vg_data/lv_data
#перенести все данные с удаляемого диска
pvmove /dev/sdc
#удалить диск из VG
vgreduce vg_data /dev/sdc
#удалить диск из PV
pvremove /dev/sdc




#create LVM disk on second disc "/dev/sdc" and move "var" dir to it
yum install lvm2 -y
pvcreate /dev/sdc
vgcreate vg_data /dev/sdc
lvcreate -n lv_data -l 100%FREE vg_data
mkfs.ext4 /dev/vg_data/lv_data
#move var directory
mkdir /mnt/newvar
mount /dev/vg_data/lv_data /mnt/newvar
df -h /mnt/newvar
rsync -aqxP /var/* /mnt/newvar
umount /mnt/newvar/
blkid
vi /etc/fstab 
# cat /etc/fstab 
#/dev/mapper/vg_data-lv_data: 
UUID=f8a22449-0462-445c-b9a0-b919a6dc1907 /var                    ext4    defaults        0 2
