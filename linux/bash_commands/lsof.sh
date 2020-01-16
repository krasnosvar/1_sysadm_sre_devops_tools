#После удаления файла место не освободилось Linux
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
