#IPTABLES
# main CHAINS
INPUT - incoming traffic
FORWARD - redirecting traffic ( in server is router, for example )
OUTPUT - outgoing traffic
# other chains
PREROUTING
POSTROUTING

#https://www.cyberciti.biz/tips/linux-iptables-examples.html
#show all rules
iptables -L
iptables -L -n -v
iptables -n -L -v --line-numbers
#display by chains
iptables -L INPUT -n -v
iptables -L OUTPUT -n -v --line-numbers


# accept all incoming traffic( for example if dorpped all rules)
iptables -I INPUT -j ACCEPT


#allow 8000 port on tcp
sudo iptables -I INPUT -p tcp --dport 8000 -j ACCEPT
sudo service iptables save

# refuse connection to 22 port to all /24 subnet
iptables -A INPUT -s 192.168.34.0/24 -p tcp --destination-port 22 -j DROP


# delete 3rd rule in INPUT chain
iptables -D INPUT 3

#insert rule in 1st position in chain (allow incoming traffic from ip 192.168.34.37)
iptables -I INPUT -s 192.168.34.37 -j ACCEPT
# insert rule in 4th position in chain INPUT
iptables -I INPUT 4 -s 192.168.34.0/24 -p tcp --destination-port 25 -j DROP


#reject all traffic ( only one IP allow)
#drop all input
iptables -P INPUT DROP
#allow localhost
iptables -A INPUT -s 127.0.0.1 -j ACCEPT
#allow jump-host ( for configuring)
iptables -A INPUT -s 192.168.122.1 -j ACCEPT
# allow ping if  needed
iptables -A INPUT -p icmp -j ACCEPT


# allow connect to ssh from all
iptables -A INPUT -p tcp --destination-port 22 -j ACCEPT


#редирект с одного порта на другой( открыт vnc 5900, но зайти можно будет через 5901)
#https://habr.com/ru/post/324276/
#https://www.cyberciti.biz/faq/linux-iptables-delete-prerouting-rule-command/
iptables -t nat -A PREROUTING -p tcp --dport 5901 -j REDIRECT --to-port 5900
#редиректить будет, но порт через ss -ntulp виден не будет


#FIREWALL-CMD(firewalld)
firewall-cmd --list-ports
firewall-cmd --list-services
#allow port on centos8
sudo firewall-cmd --get-active-zones
#output
# public
#   interfaces: ens3
sudo firewall-cmd --zone=public --add-port=8000/tcp --permanent
sudo firewall-cmd --reload
#allow 80,443 ports by service 
sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --zone=public --permanent --add-service=https

#OracleLinux allow 1521
firewall-cmd --add-port=1521/tcp
#To specify that the port be opened in future restarts of the instance, add the --permanent option
firewall-cmd  --permanent --add-port=1521/tcp
