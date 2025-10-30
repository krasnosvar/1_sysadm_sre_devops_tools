# backgroung colour Turquoise Green #30D5C8
# sudo scutil --set HostName denAir

#install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/den/.zprofile eval "$(/opt/homebrew/bin/brew shellenv)"

#inprove zsh
#show only last dir
#https://github.com/agnoster/agnoster-zsh-theme/issues/19

#zsh article
#https://blog.amd-nick.me/iterm-oh-my-zsh/
brew install oh-my-zsh
#install fonts for Terminal
#https://medium.com/@genealabs/agnoster-theme-on-os-x-391d60effaf6
#install fonts for vSCode
#https://gist.github.com/480/3b41f449686a089f34edb45d00672f28
#plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting


brew install git
git config --global user.email "krasnosvar@gmail.com"
git config --global user.name "krasnosvar"


#Main OS apps
brew install --cask keepassxc
brew install --cask maccy
# Install additional multimedia and productivity apps
brew install --cask blender
brew install --cask inkscape
brew install --cask lightshot
brew install --cask libreoffice
# Install libheif for HEIC image support
brew install libheif
brew install --cask gimp
brew install --cask telegram
brew install --cask libreoffice
brew install --cask audacity
brew install --cask veracrypt
brew install --cask vlc
brew install gnu-sed
#for VMs
brew install qemu gcc libvirt
brew install virt-manager


#Utils
brew install sevenzip
brew install smartmontools
brew install wget
brew install expect
brew install vault
brew install watch
brew install byobu
brew install tree
brew install --cask termius
brew install --cask wifi-explorer

#displaylink
brew tap homebrew/cask-drivers
brew install --cask displaylink

#browsers
brew install --cask vivaldi
brew install --cask brave-browser
brew install --cask microsoft-edge
brew install --cask google-chrome
brew install --cask opera
#firefox-based Gecko engine
brew install --cask firefox
# brew install --cask waterfox
brew install --cask floorp
brew install --cask librewolf
brew install --cask tor-browser
#firefox-based Gecko engine (Goanna fork)
# https://www.palemoon.org/download.php?mirror=us&bits=64&type=macarm



#netttols
#https://medium.com/@edgar/use-openconnect-as-a-replacement-for-cisco-anyconnect-vpn-client-in-mac-36eab0812718
# brew install openconnect
# sudo sh -c 'echo "%admin ALL=(ALL) NOPASSWD: /opt/homebrew/opt/openconnect/bin/openconnect" >> /etc/sudoers.d/den'
brew install --cask forticlient-vpn
brew install --cask wireshark
brew install sshuttle
brew install openfortivpn
# brew install sshpass
brew install esolitos/ipa/sshpass
brew install --cask remote-desktop-manager-free
#freerdp tools
# example command with gateway
# xfreerdp \
# /u:kras /p:$PASS /v:vm-hostname.example.com \
# /g:gw-hostname /gd:ad.domain /gu:kras /gp:$PASS
brew install freerdp
brew install --cask xquartz
brew install quartz-wm
# Install additional network tools
brew install mtr
brew install arp-scan


#devops-tools
brew install ansible
brew install docker docker-compose terraform
brew install terragrunt
brew install --cask docker
brew install jq yq
brew install awscli
brew install podman
brew install --cask podman-desktop
brew install --cask rancher
brew install jsonnet
brew install istioctl
brew install kubectl
# Install kubectl plugins
brew install krew
cat << 'EOF' >> ~/.zshrc
# Krew plugins
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
EOF
source ~/.zshrc
kubectl krew install neat
kubectl krew install tree
kubectl krew install topology
kubectl krew install who-can
kubectl krew install ctx
kubectl krew install ns
kubectl krew install sudo
kubectl krew install view-allocations
# Install kubectl node-shell
brew install kube-ps1
kubectl krew install node-shell
brew install k9s
brew install helm helmfile
brew install sops age
# Install helm plugins
helm plugin install https://github.com/jkroepke/helm-secrets --version v4.6.5
helm plugin install https://github.com/databus23/helm-diff --version v3.12.3
# PostgreSQL Tools
brew install libpq
# Add PostgreSQL tools to PATH
echo 'export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"' >> ~/.zshrc

# Database Versioning Tools
brew install liquibase
brew install flyway
# install tofu - free terraform
# https://opentofu.org/docs/intro/install/macos
brew install opentofu


# Database Tools
# GUI Database Clients
brew install --cask dbeaver-community
brew install --cask mongodb-compass
brew install --cask beekeeper-studio  # For PostgreSQL, MySQL, SQLite
brew install --cask another-redis-desktop-manager
# MongoDB Tools
brew tap mongodb/brew
brew install mongodb-database-tools
brew install mongosh
brew install mongodb-atlas-cli
# SQL Tools
brew install mycli  # MySQL CLI with autocomplete
brew install pgcli  # Postgres CLI with autocomplete
brew install sqlite  # SQLite
# Redis
# Install just the Redis CLI without the server
brew install redis-cli



#programming, development
brew install openjdk
brew install golang
brew install pip3
# Install additional development tools
brew install golangci-lint


# IDEs, editors
brew install --cask visual-studio-code
# Install VS Code extensions
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension ms-azuretools.vscode-docker
code --install-extension hashicorp.terraform
code --install-extension redhat.vscode-yaml
code --install-extension golang.go
code --install-extension ms-python.python
cat << EOF >> ~/.zprofile\
# Add Visual Studio Code (code)\
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"\
EOF
# install VScodium - free vscode
brew install --cask vscodium
cp ../linux/ubuntu/ubuntu__desktop_24_04_1/files/vscode/settings.json ~/Library/Application\ Support/VSCodium/User/settings.json
# install extensions
codium --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
codium --install-extension ms-azuretools.vscode-docker
codium --install-extension hashicorp.terraform
codium --install-extension redhat.vscode-yaml
codium --install-extension golang.go
codium --install-extension ms-python.python


# Arduino IDE and Tools
# Arduino IDE
brew install --cask arduino-ide
# Arduino CLI
brew install arduino-cli

# Install Arduino Lab for MicroPython
APPDIR="$HOME/Applications/arduino-lab-micropython"
mkdir -p "$APPDIR"

# Download and install Arduino Lab for MicroPython
echo "Downloading Arduino Lab for MicroPython..."
curl -L -o "$APPDIR/Arduino-Lab-for-MicroPython.zip" \
  https://github.com/arduino/lab-micropython-editor/releases/latest/download/Arduino-Lab-for-MicroPython_macOS_Universal.zip
# Extract and install the application
echo "Installing Arduino Lab for MicroPython..."
unzip -o "$APPDIR/Arduino-Lab-for-MicroPython.zip" -d "$APPDIR"
# Move to Applications
mv "$APPDIR/Arduino Lab for MicroPython.app" "/Applications/"
echo "Arduino Lab for MicroPython has been installed to /Applications/"



# AI Development Tools
brew install --cask windsurf
brew install --cask cursor
