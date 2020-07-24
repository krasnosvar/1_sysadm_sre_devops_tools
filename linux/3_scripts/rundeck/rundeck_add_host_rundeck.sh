#!/bin/sh
#<?xml version="1.0" encoding="UTF-8"?>
#<project>
#  <node name="localhost" description="Rundeck server node" tags="" hostname="localhost" osArch="amd64" osFamily="unix" osName="Linux" osVersion="3.10.0-957.12.1.el7.x86_64" username="rundeck"/>
#  <node name="v00sd10" description="v00sd10.corp.domain.ru" tags="v00sd" hostname="10.8.39.39" osArch="amd64" osFamily="unix" osName="Linux" osVersion="centos7" username="svc_rundeck" ssh-authentication="password" sh-password-storage-path="keys/svc_rundeck" sudo-command-enabled="true" sudo-password-storage-path="keys/svc_rundeck" />
#/var/rundeck/projects/BMC/etc/resources.xml
echo  "Executing <<add host to Rundeck>> script"
file=/var/rundeck/projects/$RD_OPTION_PROJECT_NAME/etc/resources.xml
newhost="<node name="$RD_OPTION_NODE_NAME" description="$RD_OPTION_DESCRIPTION" tags="$RD_OPTION_TAG" hostname="$RD_OPTION_IP_ADDRESS" osArch="amd64" osFamily="unix" osName="Linux" osVersion="centos7" username="svc_rundeck" ssh-authentication="password" sh-password-storage-path="keys/svc_rundeck" sudo-command-enabled="true" sudo-password-storage-path="keys/svc_rundeck" />\n<project>"

if [ -f $file ]; then
        tail -n 1 "$file" | wc -c | xargs -I {} truncate "$file" -s -{}
        echo $newhost >> $file

else
    echo "Inventory file does not exist!"
    echo "creating inventory file"
    createfile=`touch /var/rundeck/projects/$RD_OPTION_PROJECT_NAME/etc/resources.xml`
    echo "<?xml version="1.0" encoding="UTF-8"?>" > $file
    echo "<project>" >> $file
    #sed 's/<project>/$newhost/2' $file
    #echo "<project>" >> $file
    echo $newhost >> $file
fi
echo "Host added to Rundeck inventory in $1 project"
