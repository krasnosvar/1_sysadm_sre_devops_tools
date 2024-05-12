#Determine if filesystem or partition is mounted RO or RW via Bash Script?
grep "[[:space:]]ro[[:space:],]" /proc/mounts 


###########################################################################################
#Increasing without LVM
#https://computingforgeeks.com/resize-ext-and-xfs-root-partition-without-lvm/
ls -ld /sys/block/sd*/device
echo '1' > /sys/class/scsi_disk/0\:0\:5\:0/device/rescan
resize2fs /dev/sdf
df -Th


###########################################################################################
#How To resize an ext2/3/4 and XFS root partition without LVM
https://computingforgeeks.com/resize-ext-and-xfs-root-partition-without-lvm/
#On Ubuntu / Debian system, run
sudo apt -y install cloud-guest-utils
#For CentOS server, run
sudo yum -y install cloud-utils-growpart
lsblk
sudo growpart /dev/sda 1
sudo resize2fs /dev/sda1


#check LUNs, WWNs
ls -la /dev/disk/by-id/


###########################################################################################
#move data between disks, not lvm, not root-fs(logs storage)
#https://www.thegeekdiary.com/how-to-identifymatch-lun-presented-from-san-with-underlying-os-disk/
#To get WWID of LUN you can use the /dev/disk/by-id/ file:
ls -la /dev/disk/by-id/
#copy and see progress
cat /dev/sdc > /dev/sdd &
[1] 9192
cat /proc/9191/fdinfo/1
