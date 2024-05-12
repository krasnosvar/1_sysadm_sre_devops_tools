# oneliner to delete old snaps
# https://askubuntu.com/questions/1386455/can-i-remove-the-older-revision-package-of-duplicated-snap-packages
snap list --all | awk '/disabled/{print $1, $3}' | while read name rev; do snap remove "$name" --revision="$rev"; done
#with sudo
sudo snap list --all | awk '/disabled/{print $1, $3}' | while read name rev; do sudo snap remove "$name" --revision="$rev"; done
