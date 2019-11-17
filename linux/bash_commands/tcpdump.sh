#read pcap file
tcpdump -ttttnnr 5701-01.pcap

#снимать трафик с ens33, идущий на dst 8.8.8.8 исходящий с порта 53 
tcpdump -i ens33 dst 8.8.8.8 and src port 53 -vv
