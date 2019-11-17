vi /etc/keepalived/keepalived.conf
systemctl enable keepalived
systemctl status keepalived


#in keepalived.cfg - change:
#state MASTER
#virtual_router_id  https://it-portal.corp.domain.ru/display/serviceDaS/VRRP+ID
#auth_pass 

q
#MASTER server config
!onfiguration File for keepalived
vrrp_instance VI_1 {
    state MASTER
    interface ens192
    virtual_router_id 202
    priority 101
    advert_int 1
    garp_master_delay 5
    garp_master_refresh 60
    authentication {
        auth_type AH
        auth_pass password
    }
    virtual_ipaddress {
        10.8.182.155
    }
}


#BAckup server config
!onfiguration File for keepalived
vrrp_instance VI_1 {
    state BACKUP
    interface ens192
    virtual_router_id 202
    priority 100
    advert_int 1
    garp_master_delay 5
    garp_master_refresh 60
    authentication {
        auth_type AH
        auth_pass password
    }
    virtual_ipaddress {
        10.8.182.155
    }
}
