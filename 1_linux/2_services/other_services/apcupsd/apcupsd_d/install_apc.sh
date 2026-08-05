#!/bin/sh

#this script should be started with two arguments(ip-addresses of APC)
#bash install_apc.sh 10.12.144.191 10.12.144.192

#copy-command example for apcupsd files
#scp -r /usr/git/work/services/apcupsd/apcupsd_d krasnosvarov_dn@10.12.146.125:/home/krasnosvarov_dn

#stopping service
systemctl stop apcupsd

#setup ip addresses of APCs(given by arguments) in config files
find /etc/apcupsd/apcupsd.conf_0 -type f -exec sed -i 's/IP_ADDR_APC_ONE*/$1/g' {} + 2> /dev/null
find /etc/apcupsd/apcupsd.conf_1 -type f -exec sed -i 's/IP_ADDR_APC_TWO*/$2/g' {} + 2> /dev/null

#creating backup directory and copying files into it
mkdir $HOME/apc_backup
mv /usr/lib/systemd/system/apcupsd.service $HOME/apc_backup/
mv /etc/apcupsd/apcupsd.conf $HOME/apc_backup/
mv /etc/init.d/apcupsd $HOME/apc_backup/

#reloading systemd, it needs for excluding errors, because we are using init.d script instead service file 
systemctl daemon-reload

#copying files to config-etc directory
yes|cp * -rf /etc/apcupsd/

#copying script to init.d directory
yes|cp -f init/apcupsd /etc/init.d/

#starting sefvice
service apcupsd start

#checking connection with APC
#answer should be: ONLINE
apcaccess | grep 'STATUS' | cut -d : -f 2
