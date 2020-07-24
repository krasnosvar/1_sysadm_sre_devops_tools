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

#Посмотреть, есть ли неразмеченное место на диске одной командой
parted /dev/sda print free

#подключить новый диск(целиком) в систему(если диск до 2ТБ можно пометить как msdos, если больше 2ТБ - только как gpt)
#в parted пометить диск и указать что используется весь диск, без sda1, sda2 и т.п.
sudo parted
(parted) select /dev/sdX
(parted) mklabel gpt
(parted) mkpart primary 0% 100%
(parted) quit
sudo mkfs.ext4 /dev/sdX1
#создать папку, куда будет монтироваться диск
mkdir /var/share
mount /dev/sdc /var/share/
#сделать запись в /etc/fstab
cat /etc/fstab
UUID=00ca1bf6-016c-40bd-a2bf-1d6752e44a2b /var/share  		  ext4    defaults 	  1 1
