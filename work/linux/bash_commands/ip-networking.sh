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

#flush DNS cache
sudo service networking restart
/etc/init.d/networking restart
