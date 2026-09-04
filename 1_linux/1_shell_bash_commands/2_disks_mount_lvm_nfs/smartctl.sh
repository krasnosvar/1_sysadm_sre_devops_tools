# shellcheck shell=bash

#check SMART status
smartctl -H /dev/sdb

# Discover physical block devices first. Replace sdX/nvme0 with the real device.
lsblk -d -o NAME,MODEL,SERIAL,TRAN,ROTA,SIZE
sudo smartctl --scan-open

# Full ATA/SATA SSD or HDD report: health, attributes, errors and self-tests.
sudo smartctl -x /dev/sdX

# Show common SSD endurance fields. Attribute names are vendor-specific.
sudo smartctl -A /dev/sdX | grep -Ei \
  'wear|lifetime|remaining|percent|total_lba|power_on_hours|uncorrect|reallocated|pending'

# NVMe health via smartmontools.
sudo smartctl -x /dev/nvme0

# NVMe health via nvme-cli: wear, spare, temperature, unsafe shutdowns and media errors.
# "percentage_used" is consumed endurance, not remaining life, and may exceed 100.
sudo nvme smart-log /dev/nvme0
sudo nvme smart-log /dev/nvme0 -o json

# Start a short SMART self-test only during an acceptable I/O window.
# smartctl prints the expected completion time; inspect the log afterwards.
sudo smartctl -t short /dev/sdX
sudo smartctl -l selftest /dev/sdX

# smartctl uses a bitmask exit status; decode it with "man smartctl".
sudo smartctl -H /dev/sdX
printf 'smartctl exit status: %s\n' "$?"

# References:
# https://github.com/smartmontools/smartmontools/blob/main/src/smartctl.8.in
# https://github.com/linux-nvme/nvme-cli/blob/master/Documentation/nvme-smart-log.txt
