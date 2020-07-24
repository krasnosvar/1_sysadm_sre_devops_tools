#Отправка сообщений в syslog из оболочки
#http://ashep.org/2011/otpravka-soobshhenij-v-syslog-iz-obolochki/#.XgScdNlS9hF

#Logger makes entries in the system log.  It provides a shell command interface to the syslog(3) system log module
#simple command to nginx error file
logger -f /var/log/nginx/error.log 'Hello world!'

#send messadge 'Hello world!' with facility "local7" and level "debug' (-i key sends process ID) with tag "tag-messg"
#-p(priority) facility "local7" and level "debug'
#-i send process ID
#-s (send in the output)
#-f(send to file)
logger -sitpf local7.debug "tag-messg" 'Hello world!' /var/log/nginx/error.log
