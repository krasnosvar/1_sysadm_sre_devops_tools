# SYSTOOL
# systool - view system device information by bus, class, and topology
# how to install
# https://command-not-found.com/systool
apt-get install sysfsutils
dnf install sysfsutils

# check wi-fi kernel modules params
systool -vm iwlwifi
systool -vm iwlmvm


# MODINFO
#check info, not params
modinfo iwlwifi
modinfo iwlmvm
