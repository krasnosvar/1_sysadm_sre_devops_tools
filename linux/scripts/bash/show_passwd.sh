#!/bin/bash
# pwinfo.sh - display password information for all users
list=$(cut -d : -f 1 /etc/passwd)
for user in $list ; do
echo Password information for $user
sudo chage -l $user
echo "----------"
done
