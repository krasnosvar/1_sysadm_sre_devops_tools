#!/usr/bin/env bash


echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSTALL-CONFIGURE ZSH"
#ZSH
#https://www.zsh.org
#https://github.com/zsh-users
sudo dnf install zsh -y
# https://software.opensuse.org/download.html?project=shells%3Azsh-users%3Azsh-completions&package=zsh-completions
sudo dnf config-manager addrepo \
  --from-repofile=https://download.opensuse.org/repositories/shells:zsh-users:zsh-completions/Fedora_Rawhide/shells:zsh-users:zsh-completions.repo
sudo dnf install zsh-completions -y

# Oh My Zsh
# https://ohmyz.sh/#install
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

#zsh fonts
# for vscode
sudo cp files/Menlo_for_Powerline.ttf /usr/share/fonts/
sudo fc-cache -vf /usr/share/fonts/

# plugins
#https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

cp files/.zshrc ~/.zshrc
sudo chown -R den: /home/den
# chsh -s $(which zsh)
chsh -s /bin/zsh
which $SHELL
