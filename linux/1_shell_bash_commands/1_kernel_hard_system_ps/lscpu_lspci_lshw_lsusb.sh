# LSCPU
# lscpu - display information about the CPU architecture
lscpu|grep "Core(s)"


# LSPCI
# lspci - list all PCI devices
lspci
# show network
lspci -k| grep -A 3 -i network
0c:00.0 Network controller: Intel Corporation Meteor Lake PCH CNVi WiFi (rev 19)
	Subsystem: Intel Corporation Wi-Fi 6E AX211 160MHz
	Kernel driver in use: iwlwifi
	Kernel modules: iwlwifi
# or
# -vv    Be very verbose and display more details. This level includes everything deemed useful.
# -s [[[[<domain>]:]<bus>]:][<device>][.[<func>]] Show only devices in the specified domain (in case your machine has several host bridges
lspci -vv -s 0c:00.0




# LSHW
# lshw - list hardware
#Show RAM type
sudo lshw -short -C memory
# disk info
sudo lshw -class disk
# network info
lshw -C network


# LSUSB
# lsusb - list USB devices
