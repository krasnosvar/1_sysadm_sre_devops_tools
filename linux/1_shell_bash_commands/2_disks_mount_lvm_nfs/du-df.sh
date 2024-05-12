#опция -s выводит итоговый объям для кадого аргумента, 
#опция -h пишет нам в удобочитаемом формате, опция -c заканчивает список общей суммой.

du -shc /*

#show space usage on laptop( MAX on TOP), without extra disks
du -shc /* --exclude=/media/*  2>/dev/null |sort -hr

#пропустить одну папку( например NFS-шару), слэш в конце не указывать!
du -shc /* --exclude=/var/lov/html

#пропустить несколько папок
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