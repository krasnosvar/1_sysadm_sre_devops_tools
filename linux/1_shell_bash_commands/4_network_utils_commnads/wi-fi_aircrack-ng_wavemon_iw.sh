# check current wi-fi connection
sudo apt install wavemon -y
sudo wavemon




#or iw
# iw - wi-fi tool
sudo apt install iw

# show all wireless networks around 
sudo iw dev wlp0s20f3 scan
# only names
sudo iw dev wlp0s20f3 scan| grep SSID
# or via nmcli
# list wifi ssids arount ( should be disconnectd from known wifi)
nmcli device wifi list
# only SSIDs names
nmcli --fields SSID device wifi list


# check current wireless connect (wi-fi net info)
iw dev wlp0s20f3 link     
Connected to 14:4d:67:14:b9:32 (on wlp0s20f3)
	SSID: myWifi
	freq: 2437
	RX: 883399118 bytes (649154 packets)
	TX: 24054753 bytes (163197 packets)
	signal: -48 dBm
	rx bitrate: 5.5 MBit/s
	tx bitrate: 130.0 MBit/s MCS 15

	bss flags:	short-slot-time
	dtim period:	1
	beacon int:	100




# aircrack-ng
# Check ( scan) wi-fi networks 
# https://aircrack-ng.org/doku.php?id=airodump-ng
# https://aircrack-ng.org/doku.php?id=airmon-ng

# install
sudo apt install aircrack-ng -y

# check processes to stop
sudo airmon-ng
airmon-ng check kill

# in my case- these:
sudo systemctl status NetworkManager
sudo systemctl status avahi-daemon.socket
sudo systemctl status avahi-daemon

# stop processes to activate airodump-ng
sudo systemctl stop NetworkManager
sudo systemctl stop avahi-daemon.socket
sudo systemctl stop avahi-daemon

# start monitoring mode
sudo airmon-ng start wlp0s20f3
# start airodump-ng to scan wi-fi networks with channels
sudo airodump-ng wlp0s20f3mon


# stop monitoring mode
sudo airmon-ng stop wlp0s20f3mon

# start stopped network services
sudo systemctl start NetworkManager
sudo systemctl start avahi-daemon.socket
sudo systemctl start avahi-daemon





# ERRORS
# intel wi-fi adapter dmesg error ( didn't helped):
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
