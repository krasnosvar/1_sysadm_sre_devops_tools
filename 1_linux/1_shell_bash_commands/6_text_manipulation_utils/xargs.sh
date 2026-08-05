#http://rus-linux.net/MyLDP/consol/Linux_Xargs_Command.html
#list users in one line
cut -d: -f1 /etc/passwd| sort| xargs
