#disks by uuid
blkid
#list block devices by name
lsblk

#mount nfs command
mount -t nfs 10.8.153.11:/qsdcfiles /usr/share/tomcat/webapps/qsdc-files


#mount usb-drive
#see list of devices(usuallu sb at the end)
sudo fdisk -l

#if sd card mounted only as read-only state(remount for read-write)
hdparm -r0 /dev/sdc1
mount --options remount,rw /dev/sdc1
mount -o remount,rw /media/den/32GB-NDS1/
