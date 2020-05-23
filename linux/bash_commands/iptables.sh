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

#редирект с одного порта на другой( открыт vnc 5900, но зайти можно будет через 5901)
#https://habr.com/ru/post/324276/
#https://www.cyberciti.biz/faq/linux-iptables-delete-prerouting-rule-command/
iptables -t nat -A PREROUTING -p tcp --dport 5901 -j REDIRECT --to-port 5900
#редиректить будет, но порт через ss -ntulp виден не будет
