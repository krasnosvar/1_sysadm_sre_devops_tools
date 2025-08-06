#After deleting file space was not freed Linux
#On Linux or Unix systems, deleting a file via rm or through a file manager application 
#will unlink the file from the file system's directory structure; 
#however, if the file is still open (in use by a running process) it will still 
#be accessible to this process and will continue to occupy space on disk. 
#Therefore such processes may need to be restarted before that file's space will be cleared up on the filesystem.
https://access.redhat.com/solutions/2316
https://itfb.com.ua/posle-udaleniya-fayla-mesto-ne-osvobodilos-linux/
#check if file still opened
lsof +L1
#or(the same)
lsof| grep deleted
$ sudo lsof | grep deleted
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF      NODE NAME
cron     1623 root    5u   REG   0,21        0 395919638 /tmp/tmpfPagTZ4 (deleted)
#
echo > /proc/pid/fd/5u
#or
$ sudo kill -9 1623



# lsof with files, witch using NETWORK
#what PID uses port
lsof -i
# same, but quicklier, without name-resolv (-n no host names)
lsof -i -n
#or if we need only our ports opened( example web-server)
sudo lsof -i -P -n | grep LISTEN
# same but prettier with "lsof syntax" and only TCP
sudo lsof -iTCP -sTCP:LISTEN
# or files, connected to remote
sudo lsof -i -P -n | grep ESTABLISHED
#specific port
sudo lsof -i:22
# or with protocol type
lsof -iTCP:80


#TROUBLESHOOTING
#https://access.redhat.com/solutions/483123
Error: "lsof: no pwd entry for UID "
There are files open on the system that belong to an Active Directory user.
This occurs because lsof is unaware of Active Directory, this is not an error.

