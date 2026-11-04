#NFTABLES - default packet filter backend in Fedora/RHEL 8+/Debian 10+
# firewalld and iptables-nft write rules into nftables

#show everything
sudo nft list ruleset
sudo nft -a list ruleset          # with rule handles (needed for delete)
sudo nft list tables
sudo nft list table inet filter

#minimal stateful filter
sudo nft add table inet filter
sudo nft add chain inet filter input '{ type filter hook input priority 0; policy drop; }'
sudo nft add rule inet filter input ct state established,related accept
sudo nft add rule inet filter input iif lo accept
sudo nft add rule inet filter input tcp dport '{ 22, 80, 443 }' accept
sudo nft add rule inet filter input icmp type echo-request accept

#delete rule by handle
sudo nft delete rule inet filter input handle 7

#sets - allow list of ips
sudo nft add set inet filter admins '{ type ipv4_addr; flags interval; }'
sudo nft add element inet filter admins '{ 10.0.0.0/24, 192.168.1.10 }'
sudo nft add rule inet filter input ip saddr @admins tcp dport 22 accept

#save / restore
sudo nft list ruleset > /etc/nftables.conf
sudo nft -c -f /etc/nftables.conf      # check syntax only
sudo nft -f /etc/nftables.conf
sudo systemctl enable --now nftables

#translate old iptables rules
iptables-translate -A INPUT -p tcp --dport 22 -j ACCEPT
iptables-save > rules.v4 && iptables-restore-translate -f rules.v4

#trace packet path
sudo nft add rule inet filter input tcp dport 443 meta nftrace set 1
sudo nft monitor trace
