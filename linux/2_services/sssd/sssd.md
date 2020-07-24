##### Enter in domain by sssd


* https://www.linuxtechi.com/integrate-rhel7-centos7-windows-active-directory/
* https://serveradmin.ru/vvod-centos-7-v-domen-active-directory-i-avtorizatsiya-po-ssh-domennyih-polzovateley/
* https://docs.pagure.org/SSSD.sssd/users/ad_provider.html


1. Установить пакеты
```
yum install realmd sssd oddjob oddjob-mkhomedir adcli samba-common samba-common-tools
realm join -U svc_join v00adtest1.domain.ru
```


2. Настроить конфиг-sssd
```
realm list
id krasnosvarov_dn@domain.ru
id krasnosvarov_dn
vi  /etc/sssd/sssd.conf
service sssd restart

[root@v396-003app00 ~]# cat  /etc/sssd/sssd.conf

[sssd]
domains = domain.ru
config_file_version = 2
services = nss, pam

[domain/corp.tander.ru]
ad_server = v00adtest1.domain.ru
ad_domain = domain.ru
krb5_realm = DOMAIN.RU
realmd_tags = manages-system joined-with-adcli 
cache_credentials = True
id_provider = ad
krb5_store_password_if_offline = True
default_shell = /bin/bash
ldap_id_mapping = True

#ИЗМЕНИТЬ ЭТИ ПАРАМЕТРЫ
use_fully_qualified_names = False
fallback_homedir = /home/%u

#ДОБАВИТЬ ФИЛЬТР, чтобы пускало только группу nix_adm
#access_provider = ad
access_provider = ad
ad_access_filter = (&(memberOf=CN=nix_adm,OU=Groups,OU=gk,DC=domain,DC=ru)(unixHomeDirectory=*))

#пример фильтра для разрешения подключения двух групп ```nix_adm``` и ```ora_adm```
#ad_access_filter = (|(memberOf=CN=nix_adm,OU=Groups,OU=gk,DC=domain,DC=ru)(unixHomeDirectory=*)(CN=ORA_ADM,OU=Groups,OU=gk,DC=corp,DC=tander,DC=ru))

#пример фильтра для добавления отдельного пользователя
#ad_access_filter = (&(memberOf=CN=nix_adm,OU=Groups,OU=gk,DC=domain,DC=ru)(sAMAccountName=krasnosvarov_dn))

```


3. разрешить группе **nix_adm** исполнять sudo
```
[root@v396-003app00 ~]# cat /etc/sudoers.d/nix_adm
%nix_adm    ALL=(ALL)       ALL
```


4. Restart sssd and clear any cached information
```
systemctl restart sssd ; sss_cache -E
```



### TROUBLESHOOTING

1. если про логине не создается /home/* директория, проверить запущен ли сервис
* https://access.redhat.com/solutions/107183
```
 service oddjobd status
```
