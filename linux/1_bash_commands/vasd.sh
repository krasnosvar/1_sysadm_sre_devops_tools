#https://redhatlinux.guru/2016/06/14/quest-authentication-services-qasvas-cheat-sheet/

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
