#Как создать свою службу (unit) в systemd на CentOS 7
https://wiki.it-kb.ru/unix-linux/systemd/how-to-create-warmup-command-for-apache-httpd-via-custom-service-unit-in-systemd
---------------------------------------------------------------------------------------------

#systemctl
#To show all installed unit files use 
systemctl list-unit-files
#узнать, какие сервисы запущены в данный момент.
systemctl list-units -t service
systemctl --type=service
service --status-all
#check service name by pid
ps -ef | grep java
systemctl status 88842
#Как мне сделать так, чтобы сервис не запускался автоматически(примерб сервис cups.service)? 
sudo systemctl disable cups
#вернуть в автозагрузку
sudo systemctl enable cups
#проверить, какие сервисы были остановлены в аварийном режиме
systemctl list-units -t service --failed
systemctl --failed --type=service
#find out which dependencies unit(sshd) has
systemctl list-dependencies sshd
#список всех типов юнитов systemd
[root@test-kvm ~]# systemctl -t help
Available unit types:
service
socket
busname
target
snapshot
device
mount
automount
swap
timer
path
slice
scope
---------------------------------------------------------------------------------------------
#SYSTEMD TARGETS
Previous versions of Red Hat Enterprise Linux, which were distributed with SysV init or Upstart,
implemented a predefined set of runlevels that represented specific modes of operation. These
runlevels were numbered from 0 to 6 and were defined by a selection of system services to be run when
a particular runlevel was enabled by the system administrator. Starting with Red Hat Enterprise Linux 7,
the concept of runlevels has been replaced with systemd targets.
#Comparison of SysV runlevels with systemd targets
0 (Runlevel 0)Shut down and power off the system. 
runlevel0.target, poweroff.target 
1  Set up a rescue shell.
runlevel1.target, rescue.target
2 Set up a non-graphical multi-user system.
runlevel2.target ,multi-user.target
3 Set up a non-graphical multi-user system.
runlevel3.target , multi-user.target 
4 Set up a non-graphical multi-usersystem.
runlevel4.target , multi-user.target 
5 Set up a graphical multi-user system.
runlevel5.target, graphical.target 
6 Shut down and reboot the system.
runlevel6.target ,reboot.target 

#Lists currently loaded target units.(old command - "runlevel")
systemctl list-units --type target
#determine which target unit is used by default
systemctl het-default
#enter rescue mode in the current session
systemctl rescue
systemctl isolate rescue.target
#change the current target and enter emergency mode
systemctl emergency
systemctl isolate emergency.target

#power management commands with systemctl
systemctl halt
systemctl poweroff
systemctl reboot
systemctl suspend

#list all systend cron tasks(timers)
systemctl list-timers --all
systemctl stop unbound-anchor.timer
systemctl disable unbound-anchor.timer
