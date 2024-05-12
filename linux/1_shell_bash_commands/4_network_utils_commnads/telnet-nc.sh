#telnet quit from session
^]   ( ctrl + ] )
close

#check if port "12345" opened
telnet 192.168.1.100 12345
#in Centos8, RHEL8
nc -vnz 192.168.1.100 12345
#or( checks only connection)
#head -n 1 -shows only first line
#cut -d " " -f 4 -shows 4th word(with delimiter " ")
nc -vnz $(host coderepo| head -n 1|cut -d " " -f 4) 22
#Connection to 10.8.98.66 22 port [tcp/*] succeeded!


#open port( create listener, check port availability on remote, for example)
nc -l 5555
#or
python3 -m http.server 9999
