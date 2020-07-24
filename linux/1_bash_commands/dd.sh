#erase external USB-stick
sudo dd if=/dev/zero of=/dev/sdc bs=1M && sync

#create boot usb
#https://wiki.archlinux.org/index.php/USB_flash_installation_media
dd bs=4M if=ubuntu-20.04-desktop-amd64.iso of=/dev/sdb status=progress oflag=sync
