#!/usr/bin/env bash
ubuntu=ubuntu
#Определяем дисрибутив
if cat /etc/*release* | grep -o -m 1 $ubuntu
then

apt update -y
apt upgrade -y
apt install gnome-tweak-tool -y



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

apt update -y
apt install git -y 
apt install vim -y
#terminal multiplexors
apt install tmux -y
apt install byobu -y


apt install python3 -y
apt instapp python3-pip -y
apt install git -y


#admin tools
apt install ansible




#VM



#nettools
apt install wireshark -y
#SIP-protocol analyzer- sngrep
apt install sngrep -y

apt install nettols -y
#arp-сканер сети, сканировать локалку - arp-scan --interface=enp0s3 --localnet
apt install arp-scan -y
#mtr combines the functionality of the traceroute and ping programs in a single network diagnostic tool.
apt install mtr -y #mtr -i 0.1 rtc.podborbanka.com
#tor
apt install apt-transport-https

apt install sshpass -y

#Security
apt install keepassxc


#Virtualization
#KVM
apt install -y qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils virt-manager
#VirtualBox
echo 'deb https://download.virtualbox.org/virtualbox/debian bionic contrib' >> /etc/apt/sources.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install virtualbox-6.0
#GNS3
sudo add-apt-repository ppa:gns3/ppa
sudo apt-get update
sudo apt-get install gns3-gui -y
sudo dpkg --add-architecture i386
sudo apt-get install gns3-iou

#flatpak packadge manager
sudo apt install flatpak -y
#voip linphone
#flatpak --user install --from https://linphone.org/flatpak/linphone.flatpakref -y

#end
fi
#snap packages
if snap install vlc; then
    echo "snap is OK, installnig snap packages"
    snap install notepadqq
    snap install telegram-desktop
    #vscode
    snap install --classic code #vscode official snap
else
    echo "Snap is not working, installing apt-packages instead snaps"
    #vscode official *deb
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    apt update
    apt install code
fi

apt autoremove