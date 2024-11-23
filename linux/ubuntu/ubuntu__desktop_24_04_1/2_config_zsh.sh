#!/usr/bin/env bash


echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSTALL-CONFIGURE ZSH"
#ZSH
#https://www.zsh.org
#https://github.com/zsh-users
sudo apt install zsh -y

# Oh My Zsh
# https://ohmyz.sh/#install
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

#zsh fonts
# for vscode
sudo cp files/Menlo_for_Powerline.ttf /usr/share/fonts/
sudo fc-cache -vf /usr/share/fonts/
#fix fonts in gnonme-terminal U2404
# https://askubuntu.com/questions/1511649/ohmyzsh-agnoster-statusline-doesnt-display-correctly-in-ubuntu-24-04
gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 13'
sudo apt install fonts-powerline -y # for gnome-terminal



# plugins
#https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

cp files/.zshrc ~/.zshrc
sudo chown -R den: /home/den
chsh -s $(which zsh)
which $SHELL
