#!/usr/bin/env bash
ubuntu=ubuntu
centos=centos
#Определяем дисрибутив
if cat /etc/*release* | grep -o -m 1 $ubuntu
then
echo "Installing Ubuntu server software"
apt update -y
apt upgrade -y
apt install curl -y
#terminal multiplexors
apt install tmux -y
apt install byobu -y
#nettools
apt install nettols -y
#arp-сканер сети, сканировать локалку - arp-scan --interface=enp0s3 --localnet
apt install arp-scan -y
#mtr combines the functionality of the traceroute and ping programs in a single network diagnostic tool.
apt install mtr -y #mtr -i 0.1 rtc.podborbanka.com
apt install traceroute -y
#install docker
#Install packages to allow apt to use a repository over HTTPS:
apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
#Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#add docker repo
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
#install docker-ce
apt update -y
apt-get install docker-ce docker-ce-cli containerd.io
#docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
systemctl enable docker
systemctl start docker

apt autoremove -y
apt autoclean -y

#If disrib centos
elif cat /etc/*release* | grep -o -m 1 $centos
then
echo "Installing CentOS server software"
yum check-update -y
yum update -y --obsoletes # with flag --obsoletes - thr same as "yum upgrade"
yum install wget -y
yum install unzip -y
yum install tmux -y
yum install byobu -y
#nettools
yum install nettols -y
#arp-сканер сети, сканировать локалку - arp-scan --interface=enp0s3 --localnet
yum install arp-scan -y
#mtr combines the functionality of the traceroute and ping programs in a single network diagnostic tool.
yum install mtr -y #mtr -i 0.1 rtc.podborbanka.com
yum install traceroute -y
#install docker
#add packages
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
#add repo
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
#add main docker-ce packages
yum install docker-ce docker-ce-cli containerd.io -y
systemctl enable docker
systemctl start docker
#docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose


yum clean all
#end
fi