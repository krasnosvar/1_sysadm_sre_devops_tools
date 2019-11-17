#!/usr/bin/expect -f
# script to automticaly login via ssh
#idea from http://felipeferreira.net/2011/09/08/ssh-automatic-login/
#local pass
set password "$env(TOOR_PASS)"
#set sudo pass
set passwordroot "$env(TOOR_PASS)"
# Get name of server from script arguments
set ipaddr [lindex $argv 0]
#set timeout 10
# now connect to remote UNIX box (ipaddr) with given script to execute
spawn ssh  -o StrictHostKeychecking=no toor@$ipaddr
match_max 100000
# Look for passwod prompt
expect "*?assword:*"
send -- "$password\n"
# send blank line (r) to make sure we get back to gui
#send -- "\n"
#expect command line#
expect "*?$"
#send -- "su - r"
send -- "sudo -i\n"
# Look for passwod prompt
expect "Password:"
# Send password aka $passwordroot
set timeout 0
send -- "$passwordroot\n"
# We could do anything now as root!
# could use expect eof or exit 0 to quit
# In this case we just interact with the cmd
interact


#in one line 
#expect -c "set password "$LOCAL_PASS"; set passwordroot "$LOCAL_PASS"; set ipaddr [lindex $argv 0]; spawn ssh  -o StrictHostKeychecking=no local@$ipaddr; match_max 100000; expect "*?assword:*"; send -- "$password\n"; expect "*?$"; send -- "sudo -i\n"; expect "Password:"; send -- "$passwordroot\n"; interact"