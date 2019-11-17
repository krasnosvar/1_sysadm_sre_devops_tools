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

