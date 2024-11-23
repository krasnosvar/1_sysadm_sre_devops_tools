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


# mount ntfs volume with RW mode
# first identify NTFS disc via Disk Utility
diskutil list                                                                                                    

---
/dev/disk2 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *1.0 TB     disk2
   1:                      Linux                         209.7 GB   disk2s1
   2:               Windows_NTFS                         790.5 GB   disk2s2

# install driver and mount drive
# https://github.com/osxfuse/osxfuse/wiki/NTFS-3G
brew tap gromgit/homebrew-fuse
brew install ntfs-3g-mac
#unount from RO mode
umount /dev/disk2s2
#mount
sudo /usr/local/bin/ntfs-3g /dev/disk2s2 /Volumes/NTFS-disk -o local -o allow_other -o auto_xattr -o auto_cache
