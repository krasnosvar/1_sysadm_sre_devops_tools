#centos
yum install cockpit
systemctl enable --now cockpit.socket
firewall-cmd --add-service=cockpit
firewall-cmd --add-service=cockpit --permanent

#ubuntu
apt-get install cockpit cockpit-machines cockpit-docker
sudo systemctl enable --now cockpit.socket

https://ip-address:9090
