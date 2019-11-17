#!/bin/bash
echo "Copy files from pointed dir to your remote /home/$KRAS_USER directory"
echo "Choose dir_path: Set directory path - (D), Current directory- (C)"
read usero
case "$usero" in
    c|C) echo "Copying from $(pwd) directory"
        echo -n "Enter server IP address: "
        read server_ip
        sshpass -p $KRAS_PAS -v scp -rp $(pwd) $KRAS_USER@$server_ip:/home/$KRAS_USER
        ;;
    d|D) echo "Setting directory path to copy FROM"
        echo -n "Enter server IP address: "
        read server_ip
        echo -n "Enter directory FROM we are copying: "
        read dir_path
        sshpass -p $KRAS_PAS -v scp -rp $dir_path $KRAS_USER@$server_ip:/home/$KRAS_USER
esac
