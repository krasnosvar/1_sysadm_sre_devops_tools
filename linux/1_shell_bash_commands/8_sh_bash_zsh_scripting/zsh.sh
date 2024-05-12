apt install zsh
chsh -s /bin/zsh

echo $SHELL

#Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#zsh fonts
sudo apt-get install fonts-powerline
#or
cd ~/Downloads/
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
#fix zsh vscode agnoster
#https://medium.com/@cloverinks/oh-my-zsh-agnoster-theme-not-showing-correct-font-on-vscode-ubuntu-47b5e8dcbada
git clone https://github.com/abertsch/Menlo-for-Powerline.git
sudo mv Menlo*.tff /usr/share/fonts
Menlo for Powerline


#zsh-syntax-highlighting — добавляет подсветку синтаксиса, подсвечивает команду если в написании допущена ошибка;
#zsh-autosuggestions — предугадывает команды на основе ранее вводимых.
sudo apt install zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh


#config only last dir in prompt
In: ~/.oh-my-zsh/themes/agnoster.zsh-theme

Change the function:
# Dir: current working directory
prompt_dir() {
  prompt_segment blue black '%~'
}
to
# Dir: current working directory
prompt_dir() {
  prompt_segment blue black '%c'
}