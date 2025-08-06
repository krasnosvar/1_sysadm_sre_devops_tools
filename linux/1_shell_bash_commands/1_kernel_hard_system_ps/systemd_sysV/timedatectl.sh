#timedatectl: 
#management of time and date settings.

timedatectl

#show status
timedatectl status

#explanation of output:
Local time — local time.
Universal time — UTC or coordinated universal time. Starting point for timezone calculation.
RTC time — time in PC or server hardware clock.
Time Zone — timezone.
Network time on — shows whether the ntp-client included in systemd is enabled. Even if it's disabled, synchronization can be performed by third-party clients.
NTP synchronized — shows whether time is synchronized with ntp-server.
RTC in local TZ — shows what time is stored in hardware clock: local or universal. Thus, yes means local time, no — universal time.
#Set date and time (works only when synchronization is disabled):
timedatectl set-time "2016-02-11 20:15:01"
#Disable synchronization with ntp-server:
#In this and other similar commands from systemd set, boolean values can use 1\0, on\off, true\false.
timedatectl set-ntp 0
#Display list of timezones and set appropriate one:
timedatectl list-timezones  
timedatectl set-timezone Europe/Vienna
