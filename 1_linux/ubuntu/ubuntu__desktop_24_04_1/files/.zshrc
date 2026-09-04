export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_THEME="agnoster"
HIST_STAMPS="yyyy-mm-dd"
plugins=(git docker kubectl python zsh-autosuggestions zsh-syntax-highlighting)
[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$HOME/.local/bin:$GOPATH/bin:$PATH"
[[ -d "$HOME/.rd/bin" ]] && export PATH="$HOME/.rd/bin:$PATH"

command -v kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)
alias k=kubectl
alias rm='print -u2 "Use trash or: command rm <checked-target>"; false'

prompt_dir() {
  prompt_segment blue "$CURRENT_FG" '%1~'
}
