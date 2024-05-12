#NTP Ubuntu 18
apt install ntp ntpdate -y
sudo timedatectl set-ntp off 
echo -e "10.8.13.11      domain-ntp-server\n10.8.13.12      domain2-ntp-server" >> /etc/hosts
echo -e "server domain-ntp-server iburst" >> /etc/ntp.conf
sudo systemctl restart ntp
ntpq -p

#sync centos
ntpdate -q adcore1.corp.domain.ru
ntpstat

#or
apt install ntp ntpdate -y
sudo timedatectl set-ntp off
echo -e "server 10.8.13.11\nserver 10.8.13.12" >> /etc/ntp.conf
sudo systemctl restart ntp
ntpq -p
---------------------------------------------------------------------------------------------

#chrony
#https://chrony.tuxfamily.org/doc/4.0/chronyc.html
yum install -y chrony  
service chrony start
/etc/rc.d/init.d/chronyd start
/etc/rc.d/init.d/chronyd start
vi /etc/chrony.conf 
chkconfig chronyd on 
#maintenance commands
chronyc tracking 
chronyc sources -v 
