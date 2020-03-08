#https://wiki.centos.org/HowTos/Custom_Kernel
#install packets
#скорее всего команда yum groupinstall "Development Tools" не сработает, надо поставить пакеты вручную:
#Before installing the Development tools, run the yum clean all command. This will clear the yum cache and force it to reread any changed configuration files.
yum clean all
yum install bison byacc cscope ctags cvs diffstat doxygen flex gcc gcc-c++ gcc-gfortran gettext git indent intltool libtool patch patchutils rcs redhat-rpm-config rpm-build subversion swig systemtap
yum install ncurses-devel
yum install hmaccalc zlib-devel binutils-devel elfutils-libelf-devel
--------------------------------------------------------------------------------
#папка, в которой лежит конфиг на кассвой заливке
/usr/src/kernels/3.10.0-957.21.3.el7.centos.plus.i686


#RHEL/CentOS 7:
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#on RHEL 7 it is recommended to also enable the optional, extras, and HA repositories since EPEL packages may depend on packages from these repositories:
subscription-manager repos --enable "rhel-*-optional-rpms" --enable "rhel-*-extras-rpms"  --enable "rhel-ha-for-rhel-*-server-rpms"
