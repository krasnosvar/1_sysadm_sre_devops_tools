# Oracle Linux 8
# All documentation for Oracle Linux 8.
https://docs.oracle.com/en/operating-systems/oracle-linux/8/index.html

#download OL ISOs
http://yum.oracle.com/oracle-linux-isos.html

#instlal cloud-init
yum install cloud-init

#remove old kernels
dnf remove --oldinstallonly --setopt installonly_limit=2 kernel


# install instant client OL8
sudo dnf install oracle-instantclient-basic
dnf install oracle-instantclient-sqlplus
