#!/usr/bin/env bash
sudo apt install curl -y
#ADD repos

#clipboard manager, в настройках включить autostart
#sudo add-apt-repository ppa:hluk/copyq

# repos vivaldi
# https://help.vivaldi.com/ru/desktop-ru/install-update-ru/manual-setup-vivaldi-linux-repositories/
wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | apt-key add -
sudo add-apt-repository -y 'deb https://repo.vivaldi.com/archive/deb/ stable main'

# repos for docker
# https://docs.docker.com/engine/install/ubuntu/
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# terraform
file=terraform_1.7.1_linux_amd64.zip && wget https://hashicorp-releases.yandexcloud.net/terraform/1.4.0/$file && unzip $file && cp terraform /usr/bin/ && rm -rf $file 

apt update -y
apt upgrade -y

#Main OS apps
sudo apt install -y \ 
gnome-tweak-tool libreoffice audacious transmission sshpass htop expect tree 
# clear pdf-meta info
# pdftk file.pdf  dump_data |sed -e 's/\(InfoValue:\)\s.*/\1\ /g' | pdftk file.pdf update_info - output file_no_meta.pdf
# https://stackoverflow.com/questions/60738960/remove-pdf-metadata-removing-complete-pdf-metadata
sudo apt install pdftk -y 
#print screen program, добавить на клавишу printScr командой "flameshot gui"
sudo apt install flameshot -y
#sudo apt install copyq -y
sudo apt install diodon -y #instead of copyq
#iPhone HEIC lib
sudo apt install heif-gdk-pixbuf -y
# disk utils
# sudo smartctl --xall /dev/nvme0
# sudo nvme smart-log /dev/nvme0
sudo apt install smartmontools nvme-cli  -y
#*.msg converter ( read outlook files from thunderbird)
# https://www.matijs.net/software/msgconv/
# msgconvert YourMessage.msg
sudo apt-get install libemail-outlook-message-perl -y
#flatpak packadge manager
sudo apt install flatpak -y
#Virtualization
#KVM
sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients libvirt-dev bridge-utils virt-manager
echo 'security_driver = "none"' >> /etc/libvirt/qemu.conf
#iostat, pidstat
sudo apt install sysstat -y

#Security
sudo apt install keepassxc -y
sudo ansible -m apt -a deb=https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-Ubuntu-22.04-amd64.deb localhost

#engineering apps
sudo apt install librecad -y

#for Razer devices ( need for example to turn off RGB-logo-backlight)
# https://openrazer.github.io/#ubuntu
sudo add-apt-repository ppa:openrazer/stable -y
sudo apt install openrazer-meta -y
# https://polychromatic.app/download/ubuntu/
sudo add-apt-repository ppa:polychromatic/stable -y
sudo apt install polychromatic -y


# Browsers
#vivaldi
sudo apt install vivaldi-stable
#chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
# brave
# https://brave.com/linux/#release-channel-installation
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|\
sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update && sudo apt install brave-browser -y
#firefox-based browsers ( waterfox, librefox, Floorp)
#waterfox
# https://www.linuxcapable.com/install-waterfox-browser-on-ubuntu-linux/
curl -fsSL https://download.opensuse.org/repositories/home:hawkeye116477:waterfox/xUbuntu_22.04/Release.key |\
 sudo gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_hawkeye116477_waterfox.gpg > /dev/null
echo 'deb http://download.opensuse.org/repositories/home:/hawkeye116477:/waterfox/xUbuntu_22.04/ /' |\
 sudo tee /etc/apt/sources.list.d/home:hawkeye116477:waterfox.list
curl -fsSL https://download.opensuse.org/repositories/home:/hawkeye116477:/waterfox/xUbuntu_20.04/Release.key | sudo gpg --dearmor |\
 sudo tee /etc/apt/trusted.gpg.d/home_hawkeye116477_waterfox.gpg > /dev/null
echo 'deb http://download.opensuse.org/repositories/home:/hawkeye116477:/waterfox/xUbuntu_20.04/ /' |\
 sudo tee /etc/apt/sources.list.d/home:hawkeye116477:waterfox.list
sudo apt update -y && sudo apt install waterfox-g-kpe -y
#librewolf
# https://librewolf.net/installation/debian/
sudo apt update && sudo apt install -y wget gnupg lsb-release apt-transport-https ca-certificates
distro=$(if echo " una bookworm vanessa focal jammy bullseye vera uma " |\
 grep -q " $(lsb_release -sc) "; then lsb_release -sc; else echo focal; fi)
wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF
sudo apt update && sudo apt install librewolf -y
#floorp
# https://floorp.app/ru/download/
curl -fsSL https://ppa.ablaze.one/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
sudo curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list'
sudo apt update && sudo apt install floorp -y



#nettools
sudo apt install wireshark -y
#SIP-protocol analyzer- sngrep
sudo apt install sngrep -y
#arp-сканер сети, сканировать локалку - arp-scan --interface=enp0s3 --localnet
sudo apt install arp-scan -y
#mtr combines the functionality of the traceroute and ping programs in a single network diagnostic tool.
sudo apt install mtr -y #mtr -i 0.1 rtc.podborbanka.com
sudo apt install inetutils-traceroute -y
sudo apt install ldap-utils -y
sudo apt install openssh-server -y
wget https://filestore.fortinet.com/forticlient/forticlient_vpn_7.0.7.0246_amd64.deb -P ~/Downloads
sudo dpkg -i /home/den  /Downloads/forticlient_vpn_7.0.7.0246_amd64.deb
sudo apt install arping -y
#VPN-clients
sudo apt install sshuttle openconnect network-manager-openconnect network-manager-openconnect-gnome openfortivpn -y

#devops-tools ( containers)
sudo apt install terraform-provider-libvirt -y
sudo apt install httpie -y
#docker
sudo apt install ca-certificates curl gnupg lsb-release docker-ce docker-ce-cli containerd.io -y
usermod -aG docker den
#docker config
cat <<EOF > /etc/docker/daemon.json
{
  "dns": ["8.8.8.8"]
}
EOF
#kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin && sudo chmod +x /usr/local/bin/kubectl
#helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo bash get_helm.sh
sudo apt install age -y
#instlal sops for helm-secrets ( with age, installed by apt)
sudo ansible localhost -m apt -a deb=https://github.com/getsops/sops/releases/download/v3.7.3/sops_3.7.3_amd64.deb
helm plugin install https://github.com/jkroepke/helm-secrets --version v4.4.2 
#terminal multiplexors
sudo apt install python3-newt gawk pastebinit run-one tmux byobu -y
#podman, podman-desktop
# https://flatpak.org/setup/Ubuntu
# https://podman-desktop.io/docs/installation/linux-install
sudo apt install flatpak
sudo apt-get -y install podman
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user flathub io.podman_desktop.PodmanDesktop
# rancher-desktop
# https://docs.rancherdesktop.io/getting-started/installation/#linux
curl -s https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/Release.key | gpg --dearmor | sudo dd status=none of=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg] https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/ ./' | sudo dd status=none of=/etc/apt/sources.list.d/isv-rancher-stable.list
sudo apt update
sudo apt install rancher-desktop -y


#programming, development
sudo apt install python3-pip -y
#python3.12
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update -y
sudo apt install python3.12 python3.12-distutils python3.12-apt -y
#install go
#https://golang.org/doc/install
gover=1.20.2 && cd /home/den/Downloads && \
  wget https://go.dev/dl/go$gover.linux-amd64.tar.gz && sudo tar -C /usr/local -xzf /home/den/Downloads/go$gover.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
export GOPATH=~/go
echo "export GOPATH=~/go" >> ~/.zshrc
mkdir -p $GOPATH $GOPATH/src $GOPATH/pkg $GOPATH/bin
source ~/.zshrc
#for java keytool
sudo apt install openjdk-8-jre-headless -y
# git
sudo apt install git -y 
git config --global user.name "krasnosvar"
git config --global user.email "krasnosvar@gmail.com"
git config --global color.ui auto
git config --global core.editor "vim"
sudo apt install vim neovim -y
# install VScodium - free vscode
# https://vscodium.com/#install-on-debian-ubuntu-deb-package
# add gpg
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
# add repo
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
# install codium
sudo apt update && sudo apt install -y codium
# Migrating from VS Code to VS Codium on Linux
# https://www.roboleary.net/tools/2022/06/13/migrate-from-vscode-to-vscodium-on-linux.html
#settings with powerline font for zsh
cat <<EOF > $HOME/.config/VSCodium/User/settings.json                                                            
{
    "redhat.telemetry.enabled": false,
    "terminal.integrated.fontFamily": "Menlo for Powerline",
    "terminal.integrated.fontWeightBold": "bold",
    "[python]": {
        "editor.formatOnType": true
    },
    "go.toolsManagement.autoUpdate": true,
    "go.survey.prompt": false,
    "terminal.integrated.enableMultiLinePasteWarning": false
}
EOF                                                        
#VScode extensions
#https://stackoverflow.com/questions/34286515/how-to-install-visual-studio-code-extensions-from-command-line
#-u den code --install-extension golang.go 
sudo -u den codium --install-extension ms-python.python
sudo -u den codium --install-extension ms-toolsai.jupyter
sudo -u den codium --install-extension redhat.vscode-yaml
sudo -u den codium --install-extension ms-azuretools.vscode-docker
sudo -u den codium --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
# sudo -u den codium --install-extension redhat.vscode-openshift-extension-pack
sudo -u den codium --install-extension redhat.java
sudo -u den codium --install-extension eamodio.gitlens
sudo -u den codium --install-extension gitlab.gitlab-workflow
sudo -u den codium --install-extension hashicorp.terraform
sudo -u den codium --install-extension davidanson.vscode-markdownlint
sudo -u den codium --install-extension tomoki1207.pdf
# https://github.com/oivron/microbit-extension-vscode
sudo -u den codium --install-extension statped.microbit
# install tofu - free terraform
# https://opentofu.org/docs/intro/install/deb
# gpg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://packagecloud.io/opentofu/tofu/gpgkey | sudo gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu.gpg
sudo chmod a+r /etc/apt/keyrings/opentofu.gpg
# repo
echo \
  "deb [signed-by=/etc/apt/keyrings/opentofu.gpg] https://packagecloud.io/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg] https://packagecloud.io/opentofu/tofu/any/ any main" | \
  sudo tee /etc/apt/sources.list.d/opentofu.list > /dev/null
#  install tofu
sudo apt-get update && sudo apt-get install -y tofu


#PIPs
echo "Install PIPs"
#python linter
pip3 install flake8 flake8-broken-line pep8-naming flake8-return flake8-isort 
pip3 install ansible yq jq trash-cli
#for ansible conditions in tasks
pip3 install jmespath


#install DEBs-from-web by ansible
sudo ansible -m apt -a deb=https://apt.iteas.at/iteas/pool/main/o/openfortigui/openfortigui_0.9.8-1_amd64_jammy.deb localhost
sudo ansible -m apt -a deb=https://linux.dropbox.com/ubuntu/pool/main/dropbox_2022.12.05_amd64.deb localhost
sudo ansible -m apt -a deb=https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-2%2Bubuntu22.04_all.deb localhost
# for keychron keyboard 
sudo ansible -m apt -a deb=https://github.com/the-via/releases/releases/download/v3.0.0/via-3.0.0-linux.deb localhost


echo "Install SNAPs"
#SNAPs
sudo snap install vlc
sudo snap install code --classic
# copy settings and extensions from codium to vscode
cp -r $HOME/.config/VSCodium/User/* $HOME/.config/Code/User
# copy extensions
sudo cp -R ~/.vscode-oss ~/.vscode/extensions
#
sudo snap install notepadqq
sudo snap install gimp
sudo snap install pycharm-community --classic
sudo snap install postman
sudo snap install telegram-desktop
sudo snap install yq
sudo snap install remmina
# sudo snap install kubectl --classic
# sudo snap install docker 
sudo snap install dbeaver-ce
sudo snap install nmap
# sudo snap install teams
sudo snap install fbreader


# wget https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-1.24-Update7-Ubuntu-20.10-amd64.deb
# dkpg -i veracrypt-1.24-Update7-Ubuntu-20.10-amd64.deb
wget https://launchpad.net/veracrypt/trunk/1.26.7/+download/veracrypt-1.26.7-Ubuntu-22.04-amd64.deb
apt install libccid pcscd -y
dplg -i veracrypt-1.26.7-Ubuntu-22.04-amd64.deb

#VIM install plugins
git clone https://github.com/VundleVim/Vundle.vim.git /home/den/.vim/bundle/Vundle.vim
cat <<EOF > /home/den/.vimrc
set nocompatible              " be iMproved, required
filetype off                  " required
"set the runtime path to include Vundle and initialize"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"let Vundle manage Vundle, required"

"10 essential Vim plugins
"https://medium.com/@huntie/10-essential-vim-plugins-for-2018-39957190b7a9
Plugin 'VundleVim/Vundle.vim'
Plugin 'chr4/nginx.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'hashivim/vim-terraform'
Plugin 'bash-support.vim'
Plugin 'fatih/vim-go'
Plugin 'hdima/python-syntax'
Plugin 'scrooloose/nerdtree'
map <C-o> :NERDTreeToggle<CR>
Plugin 'itchyny/lightline.vim'
call vundle#end()            " required

filetype plugin indent on    " required
"autocmd VimEnter * NERDTree " start NERD automatically when vim opens
EOF
#install vundle plugins via cli
vim +PluginInstall +qall



#config byobu
# mkdir -p /home/den/.byobu
# touch /home/den/.byobu/windows.tmux
# cat <<EOF > /home/den/.byobu/windows.tmux
# new-session bash ; 
# new-window htop ;
# new-window vim ;
# split-window ;
# EOF


chown -R den: /home/den


#install seamonkey to read MS Outlook ".msg" files
#cat <<EOF | tee /etc/apt/sources.list.d/mozilla.list
#deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main
#EOF
#apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2667CA5C
#apt-get update
# apt-get install seamonkey-mozilla-build



#ZSH
#https://www.zsh.org
#https://github.com/zsh-users
sudo apt install zsh -y

# Oh My Zsh
# https://ohmyz.sh/#install
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

#zsh fonts
# https://blog.zhaytam.com/2019/04/19/powerline-and-zshs-agnoster-theme-in-vs-code/
wget https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.tar.xz
tar -xfv Hack-v3.003-ttf.tar.xz -C /usr/share/fonts/
git clone https://github.com/abertsch/Menlo-for-Powerline.git
sudo mv "Menlo-for-Powerline/Menlo for Powerline.ttf" /usr/share/fonts/
fc-cache -vf /usr/share/fonts/
rm -rf Menlo-for-Powerline

# plugins
#https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/den/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

cp ~/git_projects/.zshrc_linux ~/.zshrc
# cat <<EOF > ~/.zshrc
# EOF

chsh -s $(which zsh)
which $SHELL


#set background as solid color ( not photo)
gsettings set org.gnome.desktop.background picture-uri ''
gsettings set org.gnome.desktop.background picture-uri-dark ''
gsettings reset org.gnome.desktop.background color-shading-type
gsettings set org.gnome.desktop.background primary-color '#df2dd9'


sudo apt autoremove -y
sudo snap refresh && snap list --all |\
 awk '/disabled/{print $1, $3}' | while read name rev; do sudo snap remove "$name" --revision="$rev"; done
