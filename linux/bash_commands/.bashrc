#nopasswd function
function kras() {
        sshpass -p krasspasswd -v ssh -o StrictHostKeychecking=no krasnosvarov_dn@${1}
}
export -f kras

#
function loc() {
        sshpass -p localpasswd -v ssh -o StrictHostKeychecking=no local@${1}
}
export -f loc

function toor() {
        sshpass -p PASSWD -v ssh -o StrictHostKeychecking=no toor@${1}
}
export -f toor

alias menu="bash /usr/git/work/scripts/menu.sh"
alias ls="ls -lah"
alias df="df -hT"

#python pip install
pip() {
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
}
