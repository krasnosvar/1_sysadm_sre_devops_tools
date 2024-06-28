# https://iperf.fr/iperf-doc.php
sudo apt-get install iperf3
iperf3 -s
# UDP
iperf3 -M 100  -b 100G -u -c  192.168.122.147
# TCP
iperf3 -M 100  -b 100G -c  192.168.122.147
