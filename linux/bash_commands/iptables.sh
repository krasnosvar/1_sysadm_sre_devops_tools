#IPTABLES
#allow 8000 port
sudo iptables -I INPUT -p tcp --dport 8000 -j ACCEPT
sudo service iptables save


#FIREWALL-CMD(firewalld)
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
