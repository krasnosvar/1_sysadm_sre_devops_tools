export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
HIST_STAMPS="dd.mm.yyyy"

#add plugins
plugins=(ansible golang docker docker-compose git kubectl helm terraform aws k9s python zsh-syntax-highlighting zsh-autosuggestions)

source "$ZSH/oh-my-zsh.sh"


#aliases
alias push="git add . && git commit -m \"script auto commit\" && git push"
alias rm='echo "Use <<trash-put>> instead rm, to override alias use \"\\rm file-to-del\" "; false'
alias vi=nvim
alias k=kubectl



prompt_dir() {
  prompt_segment blue $CURRENT_FG '%1~'
}

export GOPATH=~/go
export PATH=$PATH:/usr/local/go/bin
if command -v go >/dev/null 2>&1; then
  export PATH="$PATH:$(go env GOPATH)/bin"
fi
export PATH="$HOME/.local/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$PATH:$HOME/.lmstudio/bin"
export PATH="$HOME/.opencode/bin:$PATH"


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

export SSH_ASKPASS=""
export GIT_SSH_COMMAND="ssh -o PasswordAuthentication=no -o KbdInteractiveAuthentication=no"

# Enable bash-style completions in Zsh. Oh My Zsh already runs compinit.
autoload -Uz bashcompinit
bashcompinit

if command -v tofu >/dev/null 2>&1; then
  complete -C "$(command -v tofu)" tofu
fi

export NVM_DIR="$HOME/.nvm"
# Loading nvm is slow; skip it while VS Code resolves the shell environment.
if [ "$VSCODE_RESOLVING_ENVIRONMENT" != "1" ]; then
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi
