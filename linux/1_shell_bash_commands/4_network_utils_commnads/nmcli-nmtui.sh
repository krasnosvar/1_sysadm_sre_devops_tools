#get complete information about known devices
nmcli device show

#get an overview on active connection profiles
nmcli connection show

#Showing Current Connection Status
nmcli conn show

#see all properties of the connection
nmcli conn show ens3

#man page with examples
man nmcli-examples

#After making changes to the configuration file, use this command to activate the new configuration
nmcli con reload

#pseudo-graphical unterface
nmtui


# list wifi ssids arount ( should be disconnectd from known wifi)
nmcli device wifi list
# only SSIDs names
nmcli --fields SSID device wifi list
