#!/bin/sh
sleep 120

terraform refresh| grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'


echo "#initial comment" > hosts
echo '[server]' >> hosts
echo '10.8.8.8' >> hosts
# count=1 # works only in bash
count=-1
for ip in $(terraform refresh| grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
do
    # (( count++ )) # works only in bash
    $(( count++ ))
    echo "[stand$count]" >> hosts
    echo "stand_u2004_$count ansible_ssh_host=$ip" >> hosts
done
