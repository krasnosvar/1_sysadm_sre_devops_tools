#option -s outputs the total volume for each argument,
#option -h writes to us in human-readable format, option -c ends the list with a total sum.

du -shc /*

#show space usage on laptop( MAX on TOP), without extra disks
du -shc /* --exclude=/media/*  2>/dev/null |sort -hr

#skip one folder (for example NFS share), don't specify slash at the end!
du -shc /* --exclude=/var/lov/html

#skip several folders
du -shc --exclude=/{proc,sys,dev} /*

#sort by size( MAX on TOP)
du -shc 1_sysadmin_devops_tools/linux/* |sort -hr
#sort by size( MAX on bottom)
du -shc 1_sysadmin_devops_tools/linux/* |sort -h


#INODES
#check inodes usage
df -i
#https://www.digitalocean.com/community/questions/best-way-to-clear-inodes
#check by dir
for i in /*; do echo $i; find $i |wc -l; done
for i in /var/*; do echo $i; find $i |wc -l; done
