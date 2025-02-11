# background colour #1d99f3

#!/usr/bin/env bash
sudo dnf upgrade --refresh
# system utils
sudo dnf -y install dnf-plugins-core plasma-workspace-x11 sysfsutils


#Main OS apps
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo dnf install git wget gnupg lsb-release apt-transport-https ca-certificates curl \
  flameshot audacity vlc telegram -y

#Virtualization
# https://docs.fedoraproject.org/en-US/quick-docs/virtualization-getting-started/
sudo dnf install @virtualization -y
sudo systemctl start libvirtd
sudo usermod -a -G libvirt den
sudo usermod -a -G kvm den
#iostat, pidstat
# https://github.com/sysstat/sysstat
sudo dnf install sysstat -y


#Security
# https://keepassxc.org/download/
sudo dnf install keepassxc -y


# Browsers
#vivaldi
# https://www.linuxcapable.com/install-vivaldi-on-fedora-linux/
sudo dnf config-manager addrepo --from-repofile=https://repo.vivaldi.com/stable/vivaldi-fedora.repo
sudo dnf install vivaldi-stable -y
#chrome
# https://docs.fedoraproject.org/en-US/quick-docs/installing-chromium-or-google-chrome-browsers/
sudo dnf install chromium -y
sudo dnf install fedora-workstation-repositories -y
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install google-chrome-stable -y
# brave
# https://brave.com/linux/#fedora-rockyrhel
sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser -y
#floorp
flatpak install --user flathub one.ablaze.floorp -y


#nettools
#arp-scan - arp-scan --interface=enp0s3 --localnet
#SIP-protocol analyzer- sngrep
#mtr combines the functionality of the traceroute and ping programs in a single network diagnostic tool.
#mtr -i 0.1 yoursite.com
sudo dnf install arp-scan mtr wireshark traceroute openssh-server arping httpie \
  sshuttle openconnect NetworkManager-openconnect openfortivpn -y
sudo usermod -a -G wireshark den


#devops-tools
# terraform
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf -y install terraform
# https://httpie.io/docs/cli/fedora
sudo dnf install httpie -y
#docker
# https://docs.docker.com/engine/install/fedora/#install-using-the-repository
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -a -G docker den
#kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# helm
# age
# https://github.com/FiloSottile/age#installation
sudo dnf install helm age httpie yq jq tmux byobu -y
flatpak install flathub io.dbeaver.DBeaverCommunity -y
# sops
# https://gist.github.com/patrickmslatteryvt/d531c5ae4598fd4c9d508833bde6c7c0
SOPS_VERSION=$(curl -s https://api.github.com/repos/getsops/sops/releases/latest | jq .tag_name | tr -d '"')
dnf install -y https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION:1}-1.x86_64.rpm
sops --version
# helm plugins
helm plugin install https://github.com/jkroepke/helm-secrets --version v4.4.2
helm plugin install https://github.com/databus23/helm-diff
# psql
sudo dnf install postgresql -y
# dbeaver
# https://dbeaver.io/download/
sudo dnf install https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm -y

#programming, development
sudo dnf install python3 python3.9 python3.10 python3.12 -y
#install go
# https://developer.fedoraproject.org/tech/languages/go/go-installation.html
sudo dnf install golang -y
#for java keytool
dnf search openjdk
# git
sudo dnf install vim neovim -y
git config --global user.name "krasnosvar"
git config --global user.email "krasnosvar@gmail.com"
git config --global color.ui auto
git config --global core.editor "nvim"
# install VScodium - free vscode
sudo dnf install codium -y
# https://vscodium.com/#install
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo
# Migrating from VS Code to VS Codium on Linux
# https://www.roboleary.net/tools/2022/06/13/migrate-from-vscode-to-vscodium-on-linux.html
# copy everything
# cp -r $HOME/.config/Code/User/* $HOME/.config/VSCodium/User
# copy extensions
# sudo cp -R ~/.vscode/extensions ~/.vscode-oss
mkdir -p $HOME/.config/VSCodium/User/
cp files/vscode/settings.json $HOME/.config/VSCodium/User/settings.json
mkdir -p $HOME/.config/Code/User/
cp files/vscode/settings.json $HOME/.config/Code/User/settings.json
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


#VScode extensions
#https://stackoverflow.com/questions/34286515/how-to-install-visual-studio-code-extensions-from-command-line

# sudo -u den codium --install-extension golang.go
# sudo -u den codium --install-extension ms-toolsai.jupyter
sudo -u den codium --install-extension ms-python.python
sudo -u den codium --install-extension redhat.vscode-yaml
sudo -u den codium --install-extension ms-azuretools.vscode-docker
sudo -u den codium --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
sudo -u den codium --install-extension redhat.java
sudo -u den codium --install-extension eamodio.gitlens
sudo -u den codium --install-extension gitlab.gitlab-workflow
sudo -u den codium --install-extension hashicorp.terraform
sudo -u den codium --install-extension davidanson.vscode-markdownlint
