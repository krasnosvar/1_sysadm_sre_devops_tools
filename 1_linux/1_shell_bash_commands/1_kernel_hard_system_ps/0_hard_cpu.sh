#Common administrative commands in Red Hat Enterprise Linux 5, 6, 7, and 8
https://access.redhat.com/articles/1189123


#oneliner show laptop hard
lscpu|grep "Core(s)" && sudo parted -l| grep "Disk /" && sudo lshw -short | grep "System"


#Show RAM type
sudo lshw -short -C memory
sudo dmidecode --type 17


#show MB manufacturer and model
sudo dmidecode -t 2


#check temperature
sudo apt install hddtemp lm-sensors
#check cpu temp
sensors


#VIDEO
#check card used
prime-select query
#switch to internal 
sudo prime-select intel
#switch to discrete
sudo prime-select nvidia


#check battery
upower –e
upower -i /org/freedesktop/UPower/devices/battery_BAT0
