#USB through parted
umount /dev/DEVICE
parted /dev/sdb
(parted) mklabel msdos
(parted) mkpart
File system type?  [ext2]? msdos
Start? 0%
End? -1s
quit
mkfs.fat /dev/sdb1

#Check if there is unallocated space on the disk with one command
parted /dev/sda print free

#connect a new disk (entirely) to the system (if disk is up to 2TB can be marked as msdos, if more than 2TB - only as gpt)
#in parted mark the disk and specify that the entire disk is used, without sda1, sda2, etc.
sudo parted
(parted) select /dev/sdX
(parted) mklabel gpt
(parted) mkpart primary 0% 100%
(parted) quit
sudo mkfs.ext4 /dev/sdX1
#create folder where the disk will be mounted
mkdir /var/share
mount /dev/sdc /var/share/
#make an entry in /etc/fstab
cat /etc/fstab
UUID=00ca1bf6-016c-40bd-a2bf-1d6752e44a2b /var/share  		  ext4    defaults 	  1 1

#one command create parttition and filesystem on it
parted /dev/sdc mklabel gpt mkpart primary 0% 100% && mkfs.ext4 /dev/sdc1



# add partition on free space at the end of disk
[root@test-vm ~]# parted /dev/sda print free
Model: VMware Virtual disk (scsi)
Disk /dev/sda: 161GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type     File system     Flags
        32,3kB  1049kB  1016kB           Free Space
 1      1049kB  525MB   524MB   primary  ext4            boot
 2      525MB   51,6GB  51,1GB  primary  ext4
 3      51,6GB  53,7GB  2097MB  primary  linux-swap(v1)
        53,7GB  161GB   107GB            Free Space

[root@test-vm ~]# parted /dev/sda mkpart primary ext4 53,7GB 161GB
# or parted /dev/sda mkpart primary ext4 53,7GB 100%
Information: You may need to update /etc/fstab.

[root@test-vm ~]# parted /dev/sda print free
Model: VMware Virtual disk (scsi)
Disk /dev/sda: 161GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type     File system     Flags
        32,3kB  1049kB  1016kB           Free Space
 1      1049kB  525MB   524MB   primary  ext4            boot
 2      525MB   51,6GB  51,1GB  primary  ext4
 3      51,6GB  53,7GB  2097MB  primary  linux-swap(v1)
 4      53,7GB  161GB   107GB   primary

