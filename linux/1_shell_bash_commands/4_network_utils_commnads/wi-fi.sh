# intel wi-fi adapter dmesg error:
# wlp0s20f3: 80 MHz not supported, disabling VHT
https://forums.linuxmint.com/viewtopic.php?t=415180
https://easylinuxtipsproject.blogspot.com/p/intel-wifi.html

iwconfig wifi-interface-name power off

#You need power management to stay off. If it doesn't, do:
sudo sed -i 's/3/2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
#Reboot

# If that doesn't keep it off, try:
sudo sed -i 's/wifi.powersave = 3/wifi.powersave = 2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
# Reboot
