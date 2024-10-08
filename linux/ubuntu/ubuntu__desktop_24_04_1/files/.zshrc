# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

export ZSH="/home/den/.oh-my-zsh"
ZSH_THEME="agnoster"
HIST_STAMPS="mm/dd/yyyy"

#add plugins
plugins=(ansible golang docker docker-compose git kubectl python zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh


#autocomplete
complete -C /usr/bin/terraform terraform
source <(kubectl completion zsh)


#aliases
alias push="git add . && git commit -m \"script auto commit\" && git push"
alias rm='echo "Use <<trash-put>> instead rm, to override alias use \"\\rm file-to-del\" "; false'



prompt_dir() {
  prompt_segment blue $CURRENT_FG '%1~'
}

export GOPATH=~/go
export PATH=$PATH:/usr/local/go/bin


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/home/den/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)


alias k=kubectl
