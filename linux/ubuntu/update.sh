#!/usr/bin/env bash

#Определяем дисрибутив
cat /etc/*release* | grep -o -m 1 centos


#flatpak packadge manager
sudo apt install flatpak



sudo add-apt-repository ppa:nilarimogard/webupd8
apt install audacious


wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb
apt install dropbox

#print screen program
sudo add-apt-repository ppa:noobslab/indicators
sudo apt update
apt install flameshot
#clipboard manager
sudo add-apt-repository ppa:hluk/copyq
sudo apt-get update
sudo apt-get install copyq

#development, dbeaver DB-manager
apt install dbeaver-ce
#vscode
url=$(wget https://go.microsoft.com/fwlink/?LinkID=760868)
apt install $url
apt update

#terminal multiplexors
apt install tmux
apt install byobu

#nettools
apt install wireshark
apt install nettols
#arp-сканер сети, сканировать локалку - arp-scan --interface=enp0s3 --localnet
apt install arp-scan
#mtr combines the functionality of the traceroute and ping programs in a single network diagnostic tool.
apt install mtr #mtr -i 0.1 rtc.podborbanka.com

#voip linphone
flatpak --user install --from https://linphone.org/flatpak/linphone.flatpakref


#end
