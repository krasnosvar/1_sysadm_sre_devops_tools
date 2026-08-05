#https://redhatlinux.guru/2016/06/14/quest-authentication-services-qasvas-cheat-sheet/
#https://www.bashpi.org/?page_id=803


vi /etc/opt/quest/vas/users.allow

#
/opt/quest/bin/vastool list users-allowed
#View status about the operating environment
/opt/quest/bin/vastool status
#Flush cached client daemon information
/opt/quest/bin/vastool flush 	
#Apply Group Policy settings
/opt/quest/bin/vgptool apply 	
#Check rather user has access to he system and which group grants that access
/opt/quest/bin/vastool user checkaccess [account] 	
#List entries in the keytab file
/opt/quest/bin/vastool ktutil list 	
#Start vas service
service vasd start 	
#Stop vas service
service vasd stop 	
#Restart vas service
service vasd restart 	


#If VAS is running and the user is in the correct group that grants access to the server than follow the steps below to reapply the VAS configuration.
#Step 1: Restart the VAS service.
service vasd restart
#Step 2: Flush the VAS cache.
/opt/quest/bin/vastool flush
#Step 3: Reapply the VAS Group Policy Settings.
/opt/quest/bin/vgptool apply

#changepass
/opt/quest/bin/vastool -u den passwd

#list AD domains
/opt/quest/bin/vastool info servers
#or if in domain already
for i in $(host corp.domain.ru| awk '{print $4}'); do host $i; done

#ERRORS
#FAILURE: 603 /etc/nsswitch.conf does not appear to be configured to use QAS
/opt/quest/bin/vastool configure nss
#FAILURE: 604 /etc/pam.d/system-auth does not appear to be configured to use QAS
/opt/quest/bin/vastool configure pam
#Ipmon updates DNS with the wrong IP address on hosts with multiple Network interface cards
#https://support.oneidentity.com/safeguard-authentication-services/kb/254173/ipmon-updates-dns-with-the-wrong-ip-address-on-hosts-with-multiple-network-interface-cards
/opt/quest/sbin/ipmond -i ens192
chkconfig ipmond off
#WARNING: 720 more than 25 vasd sockets, has <1023> open.
#https://support.oneidentity.com/safeguard-authentication-services/kb/118876/authentications-start-failing-or-high-cpu-usage-vastool-status-warning-720-more-then-20-vasd-sockets
/opt/quest/bin/vastool daemon restart vasd
