# iw - wi-fi tool
sudo apt install iw

# show all wireless networks around 
sudo iw dev wlp0s20f3 scan

# check connect  wi-fi net
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
