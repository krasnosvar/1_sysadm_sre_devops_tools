#journalctl

#sys cmds
#check journal disk usage
journalctl --disk-usage

#current boot logs
journalctl -b

# check service event and keep termimal to see new events
# The -f flag keeps the journal logs open for the service to see any new logs.
journalctl -fu falco

#Only errors:
journalctl -p err
#To see what gets into logs at the moment, use the command:
journalctl -f
#Enable persistent logging.
#By default, Ubuntu stores system journal until reboot or shutdown. 
#For most users this is sufficient, but if you want to store logs permanently, changing settings will be easy.
#If you want to limit the space allocated for log storage, 
#uncomment (remove "#") the SystemMaxUse line in /etc/systemd/journald.conf file and set your value after "=" sign (e.g. 500M).
sudo mkdir /var/log/journal
sudo systemd-tmpfiles --create --prefix /var/log/journal
sudo systemctl restart systemd-journald
#From permanently stored logs you can select entries starting from a certain date:
journalctl --since "1 hour ago"
journalctl --since "2 days ago"

journalctl --since=2016-12-20
journalctl --since=2016-12-20 --until=2016-12-21
journalctl --since 9:00 --until 9:30

#Show last 20 log lines 
journalctl -n 20

#Looking for the cause of slow boot.
#For analyzing system boot speed, systemd includes systemd-analyze utility. 
#Simply calling it from terminal, we learn how long the last boot took:
systemd-analyze
#detailed report:
systemd-analyze blame

#by unit
journalctl -u nginx.service
journalctl -u nginx.service -u mysql.service
journalctl -u apache2.service -r -o json-pretty
#separate logs for networking.service:
journalctl -b -u networking.service
