#https://wiki.centos.org/HowTos/Custom_Kernel
#install packets
#most likely the yum groupinstall "Development Tools" command won't work, need to install packages manually:
#Before installing the Development tools, run the yum clean all command. This will clear the yum cache and force it to reread any changed configuration files.
yum clean all
yum install bison byacc cscope ctags cvs diffstat doxygen flex gcc gcc-c++ gcc-gfortran gettext git indent intltool libtool patch patchutils rcs redhat-rpm-config rpm-build subversion swig systemtap
yum install ncurses-devel
yum install hmaccalc zlib-devel binutils-devel elfutils-libelf-devel
--------------------------------------------------------------------------------
#folder containing the config for custom kernel
/usr/src/kernels/3.10.0-957.21.3.el7.centos.plus.i686


#RHEL/CentOS 7:
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#on RHEL 7 it is recommended to also enable the optional, extras, and HA repositories since EPEL packages may depend on packages from these repositories:
subscription-manager repos --enable "rhel-*-optional-rpms" --enable "rhel-*-extras-rpms"  --enable "rhel-ha-for-rhel-*-server-rpms"


#CentOS 7 update kernel to v5
# https://elrepo.org/linux/kernel/el7/x86_64/RPMS/
sudo yum -y install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
#long-term
sudo yum --enablerepo=elrepo-kernel install kernel-lt
#mainline( fresher than lt)
sudo yum --enablerepo=elrepo-kernel install kernel-ml
#
sudo awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
sudo grub2-set-default 0
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo reboot
