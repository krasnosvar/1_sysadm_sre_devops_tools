# background colour #1d99f3

# OS Utils, Repos
#!/usr/bin/env bash
sudo dnf upgrade --refresh
# on non-Fedora RHEL-like distribs- enable EPEL first: https://www.redhat.com/en/blog/install-epel-linux
# Detect Fedora version
FEDORA_VERSION=$(grep -oP 'VERSION_ID=\K\d+' /etc/os-release)
FEDORA_VERSION=${FEDORA_VERSION:-$(rpm -E %fedora 2>/dev/null || echo "38")}  # Fallback to 38 if not detected

# Add RPM Fusion repo
# https://rpmfusion.org/Configuration
# RPM Fusion provides software that the Fedora Project or Red Hat doesn't want to ship
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
# add RPM Sphere repo ( install veracrypt )
# https://rpmsphere.github.io
# RPM Sphere repo (architecture-independent)
sudo dnf install -y https://github.com/rpmsphere/noarch/raw/master/r/rpmsphere-release-${FEDORA_VERSION}-1.noarch.rpm

# flatpak
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# system utils
#iostat, pidstat
# https://github.com/sysstat/sysstat
sudo dnf install -y git wget gnupg lsb-release apt-transport-https ca-certificates curl \
  dnf-plugins-core plasma-workspace-x11 sysfsutils sysstat htop
# sudo sensors-detect
# sensors
# sensors | grep -E 'temp[0-9]|Core|Tctl'
sudo dnf install lm_sensors -y
# GPU diagnostic tools
# sudo intel_gpu_top
# sudo radeontop
# sudo nvtop
sudo dnf install -y intel-gpu-tools radeontop nvtop



#Main OS apps- multimedia, office, etc.
# plugins "multimedia" for videos
# https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/
# libheif-freeworld - for open iphone HEIC format in Gwenview or GIMP
sudo dnf install -y \
  libreoffice gimp libheif-freeworld gimp-devel inkscape blender audacity vlc flameshot telegram \
  librecad kicad kicad-packages3d kicad-doc multimedia ffmpeg-libs # freecad
# screen recording, streaming
# https://github.com/obsproject/obs-studio/wiki/install-instructions#flatpak
flatpak install --user -y flathub com.obsproject.Studio

#Virtualization
# https://docs.fedoraproject.org/en-US/quick-docs/virtualization-getting-started/
sudo dnf install @virtualization -y
sudo systemctl start libvirtd
sudo usermod -a -G libvirt den
sudo usermod -a -G kvm den


#Security
# https://keepassxc.org/download/
sudo dnf install veracrypt keepassxc -y


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
sudo dnf install arp-scan mtr wireshark traceroute openssh-server arping \
  sshuttle openconnect NetworkManager-openconnect openfortivpn -y
sudo usermod -a -G wireshark den


# Database Tools
# =============
# Database CLI Client Tools
# -----------------------
# PostgreSQL client tools
sudo dnf install postgresql-client postgresql-contrib -y
# MySQL/MariaDB client
sudo dnf install mysql-client -y
# SQLite tools
sudo dnf install sqlite -y
# Redis CLI client
sudo dnf install redis-tools -y
# Enhanced CLI clients
sudo dnf install pgcli mycli litecli -y
# Universal SQL CLI with autocomplete
pip3 install --user usql
# Microsoft SQL Server client tools
curl https://packages.microsoft.com/config/rhel/8/prod.repo | sudo tee /etc/yum.repos.d/msprod.repo
sudo dnf install -y mssql-tools unixODBC-devel
# Database GUI Applications
# ------------------------
# DBeaver - Universal Database Tool
# https://dbeaver.io/download/
sudo dnf install https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm -y
# MongoDB Tools
# ------------
# MongoDB CLI tools
# mongocli - MongoDB Command Line Interface
# https://www.mongodb.com/docs/mongocli/current/install/
# Detect and set MongoDB architecture
MONGODB_ARCH=$(uname -m)
if [ "${MONGODB_ARCH}" = "x86_64" ]; then
    MONGODB_ARCH="x86_64"
elif [ "${MONGODB_ARCH}" = "aarch64" ]; then
    MONGODB_ARCH="aarch64"
else
    echo "Unsupported architecture for MongoDB: ${MONGODB_ARCH}"
    exit 1
fi

# MongoDB repository configuration
sudo tee /etc/yum.repos.d/mongodb-org-6.0.repo <<EOF
[mongodb-org-6.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/6.0/${MONGODB_ARCH}/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc
EOF
sudo dnf install mongocli mongodb-database-tools -y
# MongoDB Compass - Official GUI
# https://www.mongodb.com/try/download/compass
# Download MongoDB Compass for the correct architecture
if [ "$(uname -m)" = "x86_64" ]; then
    wget -O mongodb-compass.rpm https://downloads.mongodb.com/compass/mongodb-compass-1.40.4.x86_64.rpm
elif [ "$(uname -m)" = "aarch64" ]; then
    wget -O mongodb-compass.rpm https://downloads.mongodb.com/compass/mongodb-compass-1.40.4.aarch64.rpm
else
    echo "MongoDB Compass not available for architecture $(uname -m)"
fi
sudo dnf install -y ./mongodb-compass.rpm
rm mongodb-compass.rpm
# MongoDB Atlas CLI
# https://www.mongodb.com/docs/atlas/cli/current/install-atlas-cli/#install-the-atlas-cli.-1
# Install MongoDB Atlas CLI for the correct architecture
if [ "$(uname -m)" = "x86_64" ]; then
    sudo dnf install -y https://fastdl.mongodb.org/mongocli/mongodb-atlas-cli_1.46.2_linux_x86_64.rpm
elif [ "$(uname -m)" = "aarch64" ]; then
    sudo dnf install -y https://fastdl.mongodb.org/mongocli/mongodb-atlas-cli_1.46.2_linux_arm64.rpm
else
    echo "MongoDB Atlas CLI not available for architecture $(uname -m)"
fi
# Redis Tools
# ----------
# RedisInsight - GUI for Redis
# Download RedisInsight for the correct architecture
if [ "$(uname -m)" = "x86_64" ]; then
    wget -O redisinsight.rpm https://download.redisinsight.redis.com/latest/redisinsight-linux64.rpm
elif [ "$(uname -m)" = "aarch64" ]; then
    wget -O redisinsight.rpm https://download.redisinsight.redis.com/latest/redisinsight-linux-aarch64.rpm
else
    echo "RedisInsight not available for architecture $(uname -m)"
fi
sudo dnf install -y ./redisinsight.rpm
rm redisinsight.rpm
# SQLite Browser - GUI for SQLite
sudo dnf install sqlitebrowser -y


# DevOps-Tools
# terraform
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf -y install terraform
# install tofu - free terraform
# https://opentofu.org/docs/intro/install/rpm/
# One-liner using the official installer (RPM method):
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh | sudo bash -s -- --install-method rpm
# terragrunt
# https://github.com/gruntwork-io/terragrunt/releases
# https://terragrunt.gruntwork.io/docs/getting-started/install
sudo wget -c https://github.com/gruntwork-io/terragrunt/releases/download/v0.73.5/terragrunt_linux_amd64 \
  -O  /usr/local/bin/terragrunt
sudo chmod 0655 /usr/local/bin/terragrunt
# docker
# https://docs.docker.com/engine/install/fedora/#install-using-the-repository
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -a -G docker den
#kubectl
# Detect architecture for kubectl
ARCH=$(uname -m)
case "${ARCH}" in
    x86_64) ARCH=amd64 ;;
    aarch64) ARCH=arm64 ;;
    armv7l) ARCH=arm ;;
    ppc64le) ARCH=ppc64le ;;
    s390x) ARCH=s390x ;;
    *) echo "Unsupported architecture: ${ARCH}"; exit 1 ;;
esac

KUBE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBE_VERSION}/bin/linux/${ARCH}/kubectl"
chmod +x kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
# kubectl plugins
# cd ~/Downloads && \
OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
KREW="krew-${OS}_${ARCH}" &&
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
tar zxvf "${KREW}.tar.gz" &&
./"${KREW}" install krew && \
echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ~/.zshrc && \
source ~/.zshrc && \
kubectl krew install neat && \
kubectl krew install tree && \
kubectl krew install topology && \
kubectl krew install who-can && \
kubectl krew install ctx && \
kubectl krew install ns && \
kubectl krew install sudo && \
kubectl krew install view-allocations
# install kubectl node-shell
curl -LO https://github.com/kvaps/kubectl-node-shell/raw/master/kubectl-node_shell && \
chmod +x ./kubectl-node_shell && \
sudo mv ./kubectl-node_shell /usr/local/bin/kubectl-node_shell
#k9s
sudo dnf copr enable luminoso/k9s -y
sudo dnf install k9s -y
# helm
wget -qO- https://get.helm.sh/helm-v3.17.4-linux-amd64.tar.gz | tar xz -O linux-amd64/helm | \
  sudo tee /usr/local/bin/helm > /dev/null && sudo chmod +x /usr/local/bin/helm
# age
# https://github.com/FiloSottile/age#installation
sudo dnf install age yq jq tmux byobu awscli2 -y
# sops
# https://gist.github.com/patrickmslatteryvt/d531c5ae4598fd4c9d508833bde6c7c0
SOPS_VERSION=$(curl -s https://api.github.com/repos/getsops/sops/releases/latest | jq .tag_name | tr -d '"')
dnf install -y https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION:1}-1.x86_64.rpm
sops --version
# helm plugins
helm plugin install https://github.com/jkroepke/helm-secrets --version v4.6.5
helm plugin install https://github.com/databus23/helm-diff --version v3.12.3
# helmfile
wget -qO- https://github.com/helmfile/helmfile/releases/download/v1.1.3/helmfile_1.1.3_linux_amd64.tar.gz | sudo tar xz -C /usr/local/bin && sudo chmod +x /usr/local/bin/helmfile
# Database tools moved to the 'Database Tools' section above

# istioctl
wget -qO- https://github.com/istio/istio/releases/download/1.26.2/istioctl-1.26.2-linux-amd64.tar.gz | sudo tar xz -C /usr/local/bin && sudo chmod +x /usr/local/bin/istioctl
# jsonnet
sudo dnf install -y jsonnet


#programming, development
sudo dnf install python3 python3.9 python3.10 python3.12 -y
#install go
# https://developer.fedoraproject.org/tech/languages/go/go-installation.html
sudo dnf install golang -y
# golangci-lint --version 
sudo dnf install https://github.com/golangci/golangci-lint/releases/download/v2.3.0/golangci-lint-2.3.0-linux-amd64.rpm -y
#for java keytool
dnf search openjdk
# git, editors - nvim, vscode
sudo dnf install vim neovim -y
git config --global user.name "krasnosvar"
git config --global user.email "krasnosvar@gmail.com"
git config --global color.ui auto
git config --global core.editor "nvim"
# vscode
# https://code.visualstudio.com/docs/setup/linux
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
# install VScodium - free vscode
# https://vscodium.com/#install
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo
sudo dnf check-update
sudo dnf install code codium -y
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
# arduino
flatpak install flathub cc.arduino.IDE2
# Install Arduino Lab for MicroPython
APPDIR="$HOME/Applications/arduino-lab-micropython"
mkdir -p "$APPDIR"
cd /tmp && \
wget -O ArduinoLab.zip https://github.com/arduino/lab-micropython-editor/releases/latest/download/Arduino-Lab-for-MicroPython_Linux_X86-64.zip && \
unzip -o ArduinoLab.zip -d "$APPDIR" && \
unzip -o "$APPDIR/Arduino Lab for MicroPython-linux_x64.zip" -d "$APPDIR" && \
chmod +x "$APPDIR/arduino-lab-micropython-ide" && \
cat > ~/.local/share/applications/arduino-lab-micropython.desktop <<EOF
[Desktop Entry]
Name=Arduino Lab for MicroPython
Exec=$APPDIR/arduino-lab-micropython-ide
Icon=arduino
Type=Application
Categories=Development;Electronics;
Terminal=false
EOF
chmod +x ~/.local/share/applications/arduino-lab-micropython.desktop


#VScode extensions
#https://stackoverflow.com/questions/34286515/how-to-install-visual-studio-code-extensions-from-command-line


for ideEditor in code codium; do
$ideEditor --install-extension ms-python.python
$ideEditor --install-extension redhat.vscode-yaml
$ideEditor --install-extension ms-azuretools.vscode-docker
$ideEditor --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
$ideEditor --install-extension redhat.java
$ideEditor --install-extension eamodio.gitlens # git repo commits view directly in editor
$ideEditor --install-extension gitlab.gitlab-workflow
$ideEditor --install-extension hashicorp.terraform
$ideEditor --install-extension davidanson.vscode-markdownlint
$ideEditor --install-extension mathiasfrohlich.kotlin # kotlin syntax highlight
$ideEditor --install-extension ms-vscode-remote.remote-containers # for docker
$ideEditor --install-extension golang.Go
$ideEditor --install-extension tomoki1207.pdf # pdf reader in codium
$ideEditor --install-extension Codeium.codeium # windsurf AI plugin
$ideEditor --install-extension github.copilot-chat # ai chat
done


# Testing, debugging tools
# https://httpie.io/docs/cli/fedora
sudo dnf httpie -y
#Postman
# The Postman VS Code extension
# https://marketplace.visualstudio.com/items?itemName=Postman.postman-for-vscode
# flatpak via flatpak
# flatpak install flathub com.getpostman.Postman
flatpak install --user --assumeyes flathub rest.insomnia.Insomnia
#Insomnia
# https://insomnia.rest
# https://flathub.org/apps/rest.insomnia.Insomnia
flatpak install --user -y flathub rest.insomnia.Insomnia


# ai tools
# Cursor
# https://copr.fedorainfracloud.org/coprs/waaiez/cursor/
sudo dnf copr enable waaiez/cursor
sudo dnf install cursor
#Zed IDE
flatpak install flathub dev.zed.Zed
# Windsurf IDE
# https://windsurf.com/download/editor?os=linux
# add gpg-key
sudo rpm --import https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf
# add repo
sudo tee /etc/yum.repos.d/windsurf.repo > /dev/null <<EOF
[windsurf]
name=Windsurf Repository
baseurl=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/repo/
enabled=1
autorefresh=1
gpgcheck=1
gpgkey=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf
EOF
# install
sudo dnf install windsurf -y
# warp terminal
# https://docs.warp.dev/getting-started/readme/installation-and-setup
sudo rpm --import https://releases.warp.dev/linux/keys/warp.asc
sudo sh -c 'echo -e "[warpdotdev]\nname=warpdotdev\nbaseurl=https://releases.warp.dev/linux/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://releases.warp.dev/linux/keys/warp.asc" > /etc/yum.repos.d/warpdotdev.repo'
sudo dnf install warp-terminal
