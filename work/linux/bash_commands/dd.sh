#erase external USB-stick
sudo dd if=/dev/zero of=/dev/sdc bs=1M && sync
