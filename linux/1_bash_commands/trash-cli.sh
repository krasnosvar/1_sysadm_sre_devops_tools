https://github.com/andreafrancia/trash-cli

sudo pip3 install trash-cli

vi ~/.bashrc
alias rm='echo "Use <<trash-put>> instead rm, to override alias use \"\\rm file-to-del\" "; false'
