#!/usr/bin/env zsh
set -euo pipefail

# backgroung colour Turquoise Green #30D5C8
# sudo scutil --set HostName denAir

SCRIPT_DIR="${0:A:h}"
REPO_ROOT="${SCRIPT_DIR:h}"
FEDORA_FILES_DIR="${REPO_ROOT}/linux/fedora/files"

#install brew
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  grep -qxF 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$HOME/.zprofile" 2>/dev/null || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
  grep -qxF 'eval "$(/usr/local/bin/brew shellenv)"' "$HOME/.zprofile" 2>/dev/null || echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
fi

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
brew install --cask marta
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
# Parity with Fedora/Windows scripts: media / office / notes / comms
brew install --cask obs                 # OBS Studio - screen recording / streaming
brew install --cask davinci-resolve     # Hollywood-grade video editor
brew install --cask kdenlive            # Open-source video editor
brew install --cask figma               # UI/UX design & vector
brew install --cask drawio              # Architecture / block diagrams
brew install --cask krita               # Painting and raster graphics
brew install --cask freecad             # Parametric 3D CAD
brew install --cask sweet-home3d        # Interior design 3D CAD
brew install --cask calibre             # E-book manager
brew install --cask iina                # Modern macOS media player
brew install --cask rustdesk            # Open-source remote desktop
brew install --cask shotcut             # video editor
brew install --cask openshot-video-editor
brew install --cask obsidian            # private markdown notes
brew install --cask kicad               # EDA / PCB design
brew install --cask openscad            # programmatic 3D CAD
brew install --cask flameshot           # screenshots (Fedora parity)
brew install --cask zoom                # video conferencing
brew install --cask slack               # team chat
brew install --cask qbittorrent         # BitTorrent client (KTorrent parity)
brew install ffmpeg mpv                 # media codecs + player
brew install pdftk-java                 # PDF metadata / manipulation
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
brew install tmux screen
brew install tree
brew install --cask termius
brew install --cask wifi-explorer
# Modern CLI utilities (parity with Fedora ../1_shell_bash_commands toolkit)
# fzf: fuzzy finder; bat: better cat; eza: modern ls; ncdu: disk usage TUI; btop/htop: monitors
brew install fzf bat eza ncdu btop htop
# monitoring / net diagnostics: iperf3, socat, iftop, whois, telnet(inetutils)
brew install iperf3 socat iftop whois inetutils
# aircrack-ng (wifi audit); sshpass already installed above (esolitos tap)
brew install aircrack-ng
# pipe/compression helpers + GNU parallel + moreutils (sponge, ts, ...)
brew install pv pigz parallel moreutils
# backup / sync tools: rclone (cloud sync), restic + borgbackup (dedup backups), trash (safe rm)
brew install rclone restic borgbackup trash

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
brew install openvpn openconnect wireguard-tools
brew install --cask tunnelblick
brew install --cask wireguard
brew install --cask amneziavpn
brew install --cask v2rayu
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
# Parity with Fedora: port scanner + modern CLI utils + REST client
brew install nmap
brew install tcpdump bind
brew install ripgrep fd direnv
brew install zoxide git-delta tealdeer lazygit
brew install httpie
brew install --cask insomnia            # REST/GraphQL client
brew install --cask tigervnc-viewer     # VNC client
brew install --cask filezilla           # FTP/SFTP client
brew install --cask cyberduck           # SFTP/S3 client (macOS equivalent of WinSCP)
brew install --cask postman
brew install k6 grpcurl


#devops-tools
brew install ansible
brew install go-task
brew install docker docker-compose terraform
brew install terragrunt
brew install tflint
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
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
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
brew install --cask lens
brew install k9s
brew install helm helmfile
brew install kustomize
brew install stern dive lazydocker kind trivy
brew install sops age
# Parity with Fedora: kops (kOps clusters), packer (images)
brew install kops packer
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
brew install --cask datagrip
brew install --cask db-browser-for-sqlite
brew install --cask mongodb-compass
brew install --cask beekeeper-studio  # For PostgreSQL, MySQL, SQLite
brew install --cask another-redis-desktop-manager
brew install --cask redisinsight        # official Redis GUI (Fedora parity)
# MongoDB Tools
brew tap mongodb/brew
brew install mongodb-database-tools
brew install mongosh
brew install mongodb-atlas-cli
# SQL Tools
brew install mycli  # MySQL CLI with autocomplete
brew install pgcli  # Postgres CLI with autocomplete
brew install litecli usql
brew install sqlite  # SQLite
# Redis
# Install just the Redis CLI without the server
brew install redis-cli



#programming, development
brew install openjdk
brew install golang
brew install python
brew install ruby
brew install rust
brew install node
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
grep -qxF 'export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"' "$HOME/.zprofile" 2>/dev/null || \
  echo 'export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"' >> "$HOME/.zprofile"
# install VScodium - free vscode
brew install --cask vscodium
mkdir -p "$HOME/Library/Application Support/Code/User" "$HOME/Library/Application Support/VSCodium/User"
cp "$FEDORA_FILES_DIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
cp "$FEDORA_FILES_DIR/vscode/settings.json" "$HOME/Library/Application Support/VSCodium/User/settings.json"
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
brew install esptool

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
brew install --cask antigravity
brew install --cask warp                # Warp terminal (Fedora parity)
brew install --cask lm-studio
for editor in "${editor_commands[@]}"; do
  if command -v "$editor" >/dev/null 2>&1; then
    for extension in "${vscode_extensions[@]}"; do
      "$editor" --install-extension "$extension" --force || true
    done
  fi
done
npm install -g @anthropic-ai/claude-code @openai/codex @google/gemini-cli


vscode_extensions=(
  ms-python.python
  golang.Go
  redhat.java
  redhat.vscode-yaml
  ms-azuretools.vscode-docker
  ms-kubernetes-tools.vscode-kubernetes-tools
  hashicorp.terraform
  ms-vscode-remote.remote-containers
  eamodio.gitlens
  gitlab.gitlab-workflow
  mtxr.sqltools
  davidanson.vscode-markdownlint
  tomoki1207.pdf
  Codeium.codeium
  github.copilot-chat
  usernamehw.errorlens
  Gruntfuggly.todo-tree
  alefragnani.Bookmarks
  humao.rest-client
  esbenp.prettier-vscode
)

editor_commands=(
  code
  codium
  cursor
  antigravity
  # Windsurf/Devin naming has changed across releases; keep all known CLI names.
  windsurf
  windsurf-next
  devin
  devin-desktop
)

for editor in "${editor_commands[@]}"; do
  if command -v "$editor" >/dev/null 2>&1; then
    for extension in "${vscode_extensions[@]}"; do
      "$editor" --install-extension "$extension" --force || true
    done
  fi
done
