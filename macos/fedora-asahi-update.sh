# background colour #1d99f3

#!/usr/bin/env bash
sudo dnf upgrade --refresh
sudo dnf -y install dnf-plugins-core


#Main OS apps
#print screen program, добавить на клавишу printScr командой "flameshot gui"
sudo dnf install flameshot -y
sudo dnf install audacity vlc -y
#Virtualization
# https://docs.fedoraproject.org/en-US/quick-docs/virtualization-getting-started/
sudo dnf install @virtualization -y
sudo systemctl start libvirtd
sudo usermod -a -G libvirt den
sudo usermod -a -G kvm den
#iostat, pidstat
# https://github.com/sysstat/sysstat
sudo dnf install sysstat -y
#snap
sudo dnf install snapd -y


#Security
https://keepassxc.org/download/
sudo dnf install keepassxc -y


# Browsers
#vivaldi
# https://www.linuxcapable.com/install-vivaldi-on-fedora-linux/
sudo dnf config-manager --add-repo https://repo.vivaldi.com/stable/vivaldi-fedora.repo
sudo dnf install vivaldi-stable -y
#chrome
# https://docs.fedoraproject.org/en-US/quick-docs/installing-chromium-or-google-chrome-browsers/
sudo dnf install chromium -y
sudo dnf install fedora-workstation-repositories -y
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install google-chrome-stable -y
# brave
# https://brave.com/linux/#fedora-rockyrhel
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser -y
#floorp
flatpak install flathub one.ablaze.floorp
flatpak run one.ablaze.floorp

#nettools
sudo dnf install wireshark -y
sudo usermod -a -G wireshark den


#devops-tools
# terraform
file=terraform_1.7.1_linux_amd64.zip && wget https://hashicorp-releases.yandexcloud.net/terraform/1.4.0/$file && unzip $file && cp terraform /usr/bin/ && rm -rf $file 
# https://httpie.io/docs/cli/fedora
sudo dnf install httpie -y
#docker
# https://docs.docker.com/engine/install/fedora/#install-using-the-repository
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -a -G docker den
#kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
#helm
sudo dnf install helm -y
#terminal multiplexors
sudo dnf install tmux byobu -y
flatpak install flathub io.dbeaver.DBeaverCommunity -y

#programming, development
sudo dnf install python3-pip -y
#install go
# https://developer.fedoraproject.org/tech/languages/go/go-installation.html
sudo dnf install golang -y
#for java keytool
dnf search openjdk
# git
sudo dnf install git -y 
git config --global user.name "krasnosvar"
git config --global user.email "krasnosvar@gmail.com"
git config --global color.ui auto
git config --global core.editor "vim"
sudo dnf install vim neovim -y
# install VScodium - free vscode
sudo dnf install codium -y
# https://vscodium.com/#install
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo
# Migrating from VS Code to VS Codium on Linux
# https://www.roboleary.net/tools/2022/06/13/migrate-from-vscode-to-vscodium-on-linux.html
# copy everything
cp -r $HOME/.config/Code/User/* $HOME/.config/VSCodium/User
# copy extensions
sudo cp -R ~/.vscode/extensions ~/.vscode-oss
# install tofu - free terraform
# https://opentofu.org/docs/intro/install/rpm/
# Download the installer script:
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
# Alternatively: wget --secure-protocol=TLSv1_2 --https-only https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh
# Give it execution permissions:
chmod +x install-opentofu.sh
# Run the installer:
./install-opentofu.sh --install-method rpm
# Remove the installer:
rm install-opentofu.sh


#PIPs
echo "Install PIPs"
#
pip3 install ansible jq


#VScode extensions
#https://stackoverflow.com/questions/34286515/how-to-install-visual-studio-code-extensions-from-command-line

#-u den codium --install-extension golang.go 
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
#instlal vundle plugins via cli
vim +PluginInstall +qall


#ZSH
#https://www.zsh.org
#https://github.com/zsh-users
sudo dnf install zsh -y

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
