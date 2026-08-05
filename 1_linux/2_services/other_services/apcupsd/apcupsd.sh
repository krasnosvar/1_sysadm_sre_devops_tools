grep -v '^#' /etc/apcupsd/apcupsd.conf | sed '/^$/d' 

#service management
systemctl start apcupsd.service
systemctl status apcupsd.service

#logs
cat /var/log/apcupsd.events

#general status
apcaccess status
apcaccess | grep 'STATUS' | cut -d : -f 2
apcaccess

#check only Battery
service apcupsd status| grep -E "BATT|^B"
