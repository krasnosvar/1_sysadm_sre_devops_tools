#systemctl list-unit-files
chkconfig --list
chkconfig ipmon off
#remove script from list
chkconfig --del ipmond
