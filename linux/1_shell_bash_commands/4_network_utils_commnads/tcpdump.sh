#Dump traffic on port 514
sudo tcpdump -i lo -A udp and port 514 

#read pcap file
tcpdump -ttttnnr 5701-01.pcap

#снять трафик, идущий с интерфейса на ip-адрес
tcpdump -i ens192 dst 10.8.62.44 -vv

#снимать трафик с ens33, идущий на dst 8.8.8.8 исходящий с порта 53 
tcpdump -i ens33 dst 8.8.8.8 and src port 53 -vv

#Two commands to fetch traffic fo diagnostics
while true; do date +"%F.%T.%N"; netstat -antulp; sleep 1; done > netstat.log                                                                  
tcpdump dst host 192.33.4.12 or dst host 192.112.36.4 or dst host 192.203.230.10 > tcpdump.log


#show only HTTP headers without other info
# https://gist.github.com/mamashin/afb0e31999b1615428dede37883ef186
tcpdump -i eth0 -A -s 10240 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)' | egrep --line-buffered "^........(GET |HTTP\/|POST |HEAD )|^[A-Za-z0-9-]+: " | sed -r 's/^........(GET |HTTP\/|POST |HEAD )/\n\1/g'