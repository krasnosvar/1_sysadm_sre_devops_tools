#read pcap file
tcpdump -ttttnnr 5701-01.pcap

#снять трафик, идущий с интерфейса на ip-адрес
tcpdump -i ens192 dst 10.8.62.44 -vv

#снимать трафик с ens33, идущий на dst 8.8.8.8 исходящий с порта 53 
tcpdump -i ens33 dst 8.8.8.8 and src port 53 -vv
