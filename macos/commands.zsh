#show dns
scutil --dns
#or
cat /etc/resolv.conf


#Disable MacBook Pro and MacBook Air from Booting Automatically When Lid is Opened
sudo nvram AutoBoot=%00
#enqble
sudo nvram AutoBoot=%03

#show routes
netstat -rn

#erase USB flash ( no need umount)
diskutil eraseDisk ExFAT 128Gb /dev/disk2

