#!/bin/bash
menu_path=$KRAS_ENV_PATH/menu
MENU=(
    "LDAP attributes check"
    "Copy files or folders to remote server"
    "Execute command on server with <<sudo>> privileges"
    "Download from FILEOBMEN"
    "Connect to Test VM 10.9.32.20"
    "Connect to Test VM 10.9.32.6"
    "Exit"
)
select menu in "${MENU[@]}" ; do
    case $REPLY in
        1)bash $menu_path/menu1-ldap_ck.sh ;; 
        2)bash $menu_path/menu2-copy-files-to-serv.sh;;
        3)bash $menu_path/menu3-execute-sudo-on-server.sh ;;
        4)bash $menu_path/menu4-dwnld-from-fileobmen.sh;;
        5)/usr/bin/expect $KRAS_ENV_PATH/ssh-auto-login/ssh-kras.exp.sh 10.9.32.20;;
        6)/usr/bin/expect $KRAS_ENV_PATH/ssh-auto-login/ssh-kras.exp.sh 10.9.32.6;;
        7) break ;;
    esac
done

#test comment
