#DNF (Fedora 41+ uses dnf5, same commands)
sudo dnf upgrade --refresh
sudo dnf install -y PKG
sudo dnf remove PKG
dnf search KEYWORD
dnf info PKG
dnf provides /usr/bin/dig        # which package has the file
dnf repoquery -l PKG             # files of not installed package
dnf list --installed | grep PKG
dnf history                      # transactions
sudo dnf history undo last
sudo dnf autoremove
sudo dnf clean all
dnf repolist
sudo dnf config-manager addrepo --from-repofile=URL.repo   # dnf5 syntax
sudo dnf copr enable USER/PROJECT
sudo dnf upgrade --offline && sudo dnf offline reboot     # dnf5 offline update

#RPM
rpm -qa | grep PKG               # installed packages
rpm -qi PKG                      # info
rpm -ql PKG                      # files of installed package
rpm -qf /etc/ssh/sshd_config     # which package owns file
rpm -qpl file.rpm                # files inside rpm file
rpm -V PKG                       # verify files changed since install
rpm -q --changelog PKG | head
rpm2cpio file.rpm | cpio -idmv   # extract without installing

#FLATPAK
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak search APP
flatpak install -y flathub org.telegram.desktop
flatpak list --app
flatpak update -y
flatpak uninstall --unused
flatpak run org.telegram.desktop
flatpak override --user --filesystem=home org.telegram.desktop   # permissions
