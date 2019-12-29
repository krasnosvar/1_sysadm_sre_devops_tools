#!/usr/bin/env bash
ubuntu=ubuntu
#Определяем дисрибутив
if cat /etc/*release* | grep -o -m 1 $ubuntu
then

apt update -y
apt upgrade -y
sudo apt-get install gnome-tweak-tool -y

apt -y install openconnect network-manager-openconnect-gnome

apt install audacious -y


wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb
apt install dropbox -y

#print screen program, добавить на клавишу printScr командой "flameshot gui"
sudo add-apt-repository ppa:noobslab/indicators
sudo apt update
apt install flameshot -y
#clipboard manager, в настройках включить autostart
sudo add-apt-repository ppa:hluk/copyq
sudo apt-get update -y
sudo apt-get install copyq -y

#development, dbeaver DB-manager
apt install dbeaver-ce -y
#vscode
snap install --classic code #vscode official snap
apt update -y
apt install git -y 
apt install vim -y
#terminal multiplexors
apt install tmux -y
apt install byobu -y
#pycharm IDE
snap install pycharm-educational --classic
snap install pycharm-community --classic
apt install python3 -y
apt instapp python3-pip -y
apt install git -y

apt update -y
apt upgrade -y
#install system progs
apt install -y apt-transport-https filezilla gnome-commander copyq keepassxc zip 
#quemu-kvm tools
apt install -y qemu-kvm libvirt-bin virtinst virt-manager virt-viewer 
#network tools
apt install -y ansible sshpass net-tools nmap wget curl rsync wireshark sngrep tshark namp
#coding tools
apt install -y dbeaver-ce git tmux byobu code python3-pip python-pip




#VM
echo 'deb https://download.virtualbox.org/virtualbox/debian bionic contrib' >> /etc/apt/sources.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install virtualbox-6.0


#nettools
#SIP-protocol analyzer- sngrep
apt install sngrep -y
apt install wireshark tshark nmap tcpdump nettols -y
#arp-сканер сети, сканировать локалку - arp-scan --interface=enp0s3 --localnet
apt install arp-scan -y
#mtr combines the functionality of the traceroute and ping programs in a single network diagnostic tool.
apt install mtr -y #mtr -i 0.1 rtc.podborbanka.com
#tor
apt install apt-transport-https -y
apt install sshpass -y

#Security
apt install keepassxc


#Virtualization
#KVM
#VirtualBox
#GNS3



#flatpak packadge manager
sudo apt install flatpak
#voip linphone
#flatpak --user install --from https://linphone.org/flatpak/linphone.flatpakref -y

#snap packages
snap install vlc
snap install telegram-desktop

apt autoremove
#end
fi


# snap list | awk '{print $1}'

# chromium
# chromium-ffmpeg
# core
# core18
# gnome-3-26-1604
# gnome-3-28-1804
# gnome-calculator
# gnome-characters
# gnome-logs
# gnome-system-monitor
# gtk-common-themes
# intellij-idea-community
# libreoffice
# nmap
# notepadqq
# opera
# pycharm-community
# telegram-desktop
# tree
# vlc
