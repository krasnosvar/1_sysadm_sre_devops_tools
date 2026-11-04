##### Enter in domain by sssd


* https://www.linuxtechi.com/integrate-rhel7-centos7-windows-active-directory/
* https://serveradmin.ru/vvod-centos-7-v-domen-active-directory-i-avtorizatsiya-po-ssh-domennyih-polzovateley/
* https://docs.pagure.org/SSSD.sssd/users/ad_provider.html


1. Install packages
```
yum install realmd sssd oddjob oddjob-mkhomedir adcli samba-common samba-common-tools
realm join -U svc_join adtest.domain.ru
```


2. Configure sssd config
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

[domain/corp.domain.ru]
ad_server = adtest.domain.ru
ad_domain = domain.ru
krb5_realm = DOMAIN.RU
realmd_tags = manages-system joined-with-adcli 
cache_credentials = True
id_provider = ad
krb5_store_password_if_offline = True
default_shell = /bin/bash
ldap_id_mapping = True

#CHANGE THESE PARAMETERS
use_fully_qualified_names = False
fallback_homedir = /home/%u

#ADD FILTER to allow only nix_adm group
#access_provider = ad
access_provider = ad
ad_access_filter = (&(memberOf=CN=nix_adm,OU=Groups,OU=gk,DC=domain,DC=ru)(unixHomeDirectory=*))

#example filter for allowing connection of two groups ```nix_adm``` and ```ora_adm```
#ad_access_filter = (|(memberOf=CN=nix_adm,OU=Groups,OU=gk,DC=domain,DC=ru)(unixHomeDirectory=*)(CN=ORA_ADM,OU=Groups,OU=gk,DC=corp,DC=domain,DC=ru))

#example filter for adding individual user
#ad_access_filter = (&(memberOf=CN=nix_adm,OU=Groups,OU=gk,DC=domain,DC=ru)(sAMAccountName=krasnosvarov_dn))

```


3. allow group **nix_adm** to execute sudo
```
[root@v396-003app00 ~]# cat /etc/sudoers.d/nix_adm
%nix_adm    ALL=(ALL)       ALL
```


4. Restart sssd and clear any cached information
```
systemctl restart sssd ; sss_cache -E
```



### TROUBLESHOOTING

1. if /home/* directory is not created during login, check if service is running
* https://access.redhat.com/solutions/107183
```
 service oddjobd status
```


SSSD Authentication with AD fails with a MEMORY:/etc/krb5.keytab error

<!-- https://www.suse.com/support/kb/doc/?id=000020793 -->