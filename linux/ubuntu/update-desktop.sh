#!/usr/bin/env bash
#Определяем дисрибутив
if cat /etc/*release* | grep -o -m 1 ubuntu
then

sudo add-apt-repository ppa:noobslab/indicators -y
sudo add-apt-repository ppa:hluk/copyq -y
#sudo add-apt-repository ppa:longsleep/golang-backports -y #repo for golang(deprecated, installs via snap)
apt update -y
apt upgrade -y
sudo apt-get install gnome-tweak-tool -y

apt install audacious -y

#install SYSTEM progs
apt install -y apt-transport-https filezilla gnome-commander copyq keepassxc zip expect
apt install gparted -y
#print screen program, добавить на клавишу printScr командой "flameshot gui"
apt install flameshot -y
sudo apt install copyq -y
#clipboard manager, в настройках включить autostart
#VIRT quemu-kvm tools
apt install -y qemu-kvm libvirt-bin virtinst virt-manager virt-viewer 
#NETWORK tools
#for work vpn
apt -y install openconnect network-manager-openconnect-gnome
#sip-protocol analyzer- sngrep
apt install -y ansible sshpass net-tools nmap wget curl rsync wireshark sngrep tshark namp inetutils-traceroute
#mtr combines the functionality of the traceroute and ping programs in a single network diagnostic tool.
apt install mtr -y #mtr -i 0.1 rtc.podborbanka.com
apt install arp-scan -y #arp-сканер сети, сканировать локалку - arp-scan --interface=enp0s3 --localnet

#CODING tools
apt install -y git git-flow tmux byobu 
apt install -y python3-pip python-pip
#apt install -y golang-go #no need, installed through snap

#for usb-flash-drives
apt install -y exfat-fuse exfat-utils
#for docker
apt install apt-transport-https -y
apt install sshpass -y

#Security
apt install keepassxc -y

#GAMING
sudo add-apt-repository ppa:bearoso/ppa
sudo apt-get install snes9x-gtk -y


#flatpak packadge manager
sudo apt install -y flatpak
#voip linphone
#flatpak --user install --from https://linphone.org/flatpak/linphone.flatpakref -y

#snap packages
# snap list | awk '{print $1}'
snap install --classic code #vscode official snap
snap install vlc
snap install telegram-desktop
snap install chromium
snap install chromium-ffmpeg
snap install intellij-idea-community --classic
snap install libreoffice
snap install notepadqq
snap install opera
snap install pycharm-community --classic
snap install tree
snap install vlc
snap install dbeaver-ce
sudo snap install --classic go
#add:
#GNS3
#docker


#clean packages
apt autoremove
#end
#fi
