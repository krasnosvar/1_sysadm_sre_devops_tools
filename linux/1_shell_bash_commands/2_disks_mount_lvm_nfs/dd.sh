#create boot usb
#https://wiki.archlinux.org/index.php/USB_flash_installation_media
dd bs=4M if=ubuntu-20.04-desktop-amd64.iso of=/dev/sdb status=progress oflag=sync

#erase external USB-stick
sudo dd if=/dev/zero of=/dev/sdc bs=1M && sync
#parted create partition and FS - fat32 on erased USB
sudo parted -s /dev/sdc -- mklabel msdos mkpart p 0% 100% && sudo mkfs.vfat /dev/sdc1
