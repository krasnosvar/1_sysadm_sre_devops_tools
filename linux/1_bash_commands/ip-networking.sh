#assign IP to specific interfaces
sudo ip addr add 192.168.50.5 dev eth1

#remove IP from interface
ip addr del 192.168.50.5/24 dev eth1

#config net in CEntOS
vi /etc/sysconfig/network-scripts/ifcfg-eth0
#syntax
DEVICE="eth0"
BOOTPROTO=static
ONBOOT=yes
TYPE="Ethernet"
IPADDR=192.168.50.2
NAME="System eth0"
HWADDR=00:0C:29:28:FD:4C
GATEWAY=192.168.50.1

#Ubuntu config net
vi /etc/network/interfaces
auto eth0
iface eth0 inet static
address 192.168.50.2
netmask 255.255.255.0
gateway 192.168.50.1

#NETPLAN Ubuntu configuration
den@u-docker:~$ cat /etc/netplan/00-installer-config.yaml 
# This is the network config written by 'subiquity'
network:
  version: 2
  ethernets:
    ens3:
      dhcp4: no
      dhcp6: no
      addresses: [192.168.122.11/24, ]
      gateway4:  192.168.122.1
      nameservers:
              addresses: [192.168.122.1, 8.8.8.8]

#apply config
sudo netplan apply


#flush DNS cache
sudo service networking restart
/etc/init.d/networking restart
