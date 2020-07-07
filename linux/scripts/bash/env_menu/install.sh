env_dir_path=$(pwd)

echo "Enter LDAP login and password"
# -p which allows you to specify a prompt and -s which makes the input silent
read -p 'Domain Login: ' ldapuser
read -sp 'Domain Password: ' ldappass
#local login-pass
read -sp 'user "local" Password: ' local_pass
read -sp 'user "toor" Password: ' toor_pass
echo
echo Thankyou, $ldapuser. 

#setting main environment variables
echo "export KRAS_PAS="$ldappass"">> /etc/environment
echo "export KRAS_USER="$ldapuser"">> /etc/environment
echo "export KRAS_ENV_PATH="$env_dir_path"">> /etc/environment
#local-toor password as variables
echo "export LOCAL_PASS="$local_pass"">> /etc/environment
echo "export TOOR_PASS="$toor_pass"">> /etc/environment

source /etc/environment

#changing /etc/environment
echo "PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\" 
http_proxy=\"http://$ldapuser:$ldappass@mwg.corp.domain.ru:3128/\" 
https_proxy=\"http://$ldapuser:$ldappass@mwg.corp.domain.ru:3128\" 
ftp_proxy=\"ftp://$ldapuser:$ldappass@mwg.corp.domain.ru:3128/\" 
socks_proxy=\"http://$ldapuser:$ldappass@mwg.corp.domain.ru:3128/\" 
NO_PROXY=\"localhost,127.0.0.0/24,coderepo.corp.domain.ru,rpm-dr.corp.domain.ru\" 
no_proxy=\"localhost,127.0.0.0/24,coderepo.corp.domain.ru,rpm-dr.corp.domain.ru,corp.domain.ru\"" >> /etc/environment

cp /etc/environment /etc/environment_backup


#add passwordless-entrance scripts 
echo '#passwordless enter
#path to auto-ssh expect scripts
passwordless_path=$KRAS_ENV_PATH/ssh-auto-login
alias kras="expect $passwordless_path/ssh-kras.exp.sh"
alias loc="expect $passwordless_path/ssh-local.exp.sh"
alias toor="expect $passwordless_path/ssh-toor.exp.sh"
#shorting commands 
alias menu="bash $KRAS_ENV_PATH/menu/menu.sh"
alias ls="ls -lahi"
alias ll="ls -lahi"
alias df="df -hT"
alias netstat="netstat -ntulp"
alias push="git add . && git commit -m "usual-commit" && git push"' >> /etc/bash.bashrc


echo "#bash-history inproving variables:
#https://www.shellhacks.com/ru/tune-command-line-history-bash/
#date and time in history
export HISTTIMEFORMAT='%h %d %H:%M:%S '
#emmidiatly record command-history
PROMPT_COMMAND='history -a'
#can be "turned ON" on ubuntu
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=2000
# don't put duplicate lines or lines starting with space in the history(do not save command started with space and do not save last duplicating commands).
HISTCONTROL=ignoreboth">> /etc/bash.bashrc

#python pip install with proxy shortering
echo 'pip() {
    if [[ $1 == "install" ]]; then
        command sudo pip install --index-url http://pypi.corp.domain.ru:10081/root/pypi/+simple/ --trusted-host pypi.corp.domain.ru $2
    else
        command sudo pip "$@"
    fi
}

#python pip3 install
pip3() {
    if [[ $1 == "install" ]]; then
        command sudo pip3 install --index-url http://pypi.corp.domain.ru:10081/root/pypi/+simple/ --trusted-host pypi.corp.domain.ru $2
    else
        command sudo pip3 "$@"
    fi
}'>> /etc/bash.bashrc

#set all variables above
source /etc/environment
source /etc/bash.bashrc

######PACKETS INSTALL in the end of script, because if any error- script will stop and not set variables and sources
#changing /etc/apt/apt.conf
echo "Acquire::http::proxy \"http://$ldapuser:$ldappass@mwg.corp.domain.ru:3128/\";
Acquire::https::proxy \"https:/$ldapuser:$ldappass@mwg.corp.domain.ru:3128/\";
Acquire::ftp::proxy \"http://$ldapuser:$ldappass@mwg.corp.domain.ru:3128/\";
Acquire::socks::proxy \"http://$ldapuser:$ldappass@mwg.corp.domain.ru:3128/\";" > /etc/apt/apt.conf

#adding repos
echo 'deb https://download.virtualbox.org/virtualbox/debian bionic contrib
deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main
deb http://ppa.launchpad.net/phoerious/keepassxc/ubuntu bionic main
deb https://download.docker.com/linux/ubuntu bionic stable' > /etc/apt/sources.list.d/env_menu.list

#install copyq repository
sudo add-apt-repository ppa:hluk/copyq

apt update -y
apt upgrade -y
#install system progs
apt install -y apt-transport-https filezilla gnome-commander copyq keepassxc zip 
#quemu-kvm tools
apt install -y qemu-kvm libvirt-bin virtinst virt-manager virt-viewer 
#network tools
apt install -y ansible sshpass net-tools nmap wget curl rsync wireshark sngrep
#coding tools
apt install -y dbeaver-ce git tmux byobu code python3-pip python-pip 
