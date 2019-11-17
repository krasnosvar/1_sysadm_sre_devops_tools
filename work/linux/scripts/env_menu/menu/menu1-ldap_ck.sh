#!/bin/sh
#
echo "LDAP attributes check"
echo -n "Проверяем сервер или пользователя? (s/u)"
read item


case "$item" in
    s|S) echo "Server check"
         echo " Enter server ip-address"
         read server
         #execute command from confluence
        ldapsearch -h adldap.corp.domain.ru -LLL -D "$KRAS_USER@corp.domain.ru" -W -b "dc=corp,dc=domain,dc=ru" -s sub "(cn=$server)" userAccountControl sAMAccountName dNSHostName userPrincipalName servicePrincipalName
        ;;
    u|U) echo "User check"
         echo " Enter user login"
         read usr_log
         #execute command from confluence
        ldapsearch -h adldap.corp.domain.ru -LLL -D "$KRAS_USER@corp.domain.ru" -W -b "dc=corp,dc=domain,dc=ru" -s sub "(cn=$usr_log)" loginShell unixHomeDirectory memberOf 
esac
