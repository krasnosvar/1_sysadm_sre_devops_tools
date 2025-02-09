# inter linux wifi firmware
https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git

# useful links
https://wiki.debian.org/iwlwifi


# if intel adapter- check module version
modinfo iwlwifi | grep version


# iwconfig - configure a wireless network interface
# wi-fi info
iwconfig


#troubleshooting
# https://askubuntu.com/questions/1283313/unstable-wifi-connection-on-ubuntu-20-04
#check info, not params
modinfo iwlwifi
modinfo iwlmvm
# or
cat /sys/module/iwlwifi/parameters/power_level

# check configs
cat /etc/modprobe.d/iwlwifi.conf
# /etc/modprobe.d/iwlwifi.conf
# iwlwifi will dyamically load either iwldvm or iwlmvm depending on the
# microcode file installed on the system.  When removing iwlwifi, first
# remove the iwl?vm module and then iwlwifi.
remove iwlwifi \
(/sbin/lsmod | grep -o -e ^iwlmvm -e ^iwldvm -e ^iwlwifi | xargs /sbin/rmmod) \
&& /sbin/modprobe -r mac80211


# modinfo iwlwifi
# parm: 11n_disable:disable 11n functionality, bitmap: 1: full, 2: disable agg TX, 4: disable agg RX, 8 enable agg TX (uint)
# disables 11n connections
# options iwlwifi 11n_disable=1 
# enables software crypto
options iwlwifi swcrypto=1
# disables power management
options iwlwifi power_save=0 
options iwlmvm power_scheme=1
# disables 11ac connection
options iwlwifi disable_11ac=1
# disables 11ax connections 
options iwlwifi disable_11ax=1


# apply params without reboot
sudo modprobe -r iwlmvm || sudo modprobe -r iwlwifi || sudo modprobe iwlmvm || sudo modprobe iwlwifi
