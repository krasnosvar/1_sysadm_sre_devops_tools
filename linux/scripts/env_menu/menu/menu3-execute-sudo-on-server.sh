#!/bin/bash
echo "Command will be executed on server with sudo privileges"
echo "Choose user: krasnosvarov_dn - (k), local- (l)"
read usero
case "$usero" in
    k|K) echo "<<$KRAS_USER>> executes sudo command"
        echo -n "Enter server IP address: "
        read item
        echo -n "Enter command: "
        read command
        sshpass -p $KRAS_PAS -v ssh -t -o StrictHostKeychecking=no krasnosvarov_dn@$item "echo $KRAS_PAS | sudo -S -s /bin/bash -c $command"

        ;;
    l|local) echo "<<local>> executes sudo command"
        echo -n "Enter server IP address: "
        read item
        echo -n "Enter command: "
        read command
        sshpass -p Gfhjkmjnkjrfkf\!1 -v ssh -t -o StrictHostKeychecking=no local@$item "echo Gfhjkmjnkjrfkf\!1 | sudo -S -s /bin/bash -c $command"
esac
