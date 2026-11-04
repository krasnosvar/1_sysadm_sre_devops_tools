#WIREGUARD
# install: sudo dnf install wireguard-tools | sudo apt install wireguard

#keys
umask 077
wg genkey | tee privatekey | wg pubkey > publickey
wg genpsk > presharedkey

#/etc/wireguard/wg0.conf - server
[Interface]
Address = 10.10.0.1/24
ListenPort = 51820
PrivateKey = <server-private-key>

[Peer]
PublicKey = <client-public-key>
AllowedIPs = 10.10.0.2/32

#/etc/wireguard/wg0.conf - client
[Interface]
Address = 10.10.0.2/24
PrivateKey = <client-private-key>
DNS = 10.10.0.1

[Peer]
PublicKey = <server-public-key>
Endpoint = vpn.example.com:51820
AllowedIPs = 10.10.0.0/24        # 0.0.0.0/0 - route all traffic via VPN
PersistentKeepalive = 25

#up / down / autostart
sudo wg-quick up wg0
sudo wg-quick down wg0
sudo systemctl enable --now wg-quick@wg0

#status: peers, latest handshake, transfer
sudo wg show
sudo wg show wg0 latest-handshakes

#NetworkManager import
nmcli connection import type wireguard file /etc/wireguard/wg0.conf

#server needs forwarding for routing to other networks
sudo sysctl -w net.ipv4.ip_forward=1
