#INODES
#check inodes usage
df -i
#https://www.digitalocean.com/community/questions/best-way-to-clear-inodes
#check by dir
for i in /*; do echo $i; find $i |wc -l; done
for i in /var/*; do echo $i; find $i |wc -l; done
