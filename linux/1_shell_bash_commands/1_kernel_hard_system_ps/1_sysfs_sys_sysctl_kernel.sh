#/SYS
# /sys is an interface to the kernel. 
# Specifically, it provides a filesystem-like view of information and configuration settings 
# that the kernel provides, much like /proc. Writing to these files may or may not write to the actual device, 
# depending on the setting you're changing. It isn't only for managing devices, though that's a common use case.
# More information can be found in the kernel documentation:
# https://www.kernel.org/doc/Documentation/filesystems/sysfs.txt




#SYSCTL
# Любые изменения, сделанные с помощью sysctl, работают до первой перезагрузки. 
# Чтобы эти изменения действовали после перезагрузки, необходимо открыть файл /etc/sysconf 
# в любом текстовом редакторе и внести изменения в него. В этом файле содержатся не все параметры ядра, 
# поэтому если вы не нашли в нем нужный параметр, то просто добавьте его вместе с нужным значением.
https://wiki.archlinux.org/title/Sysctl
https://access.redhat.com/documentation/ru-ru/red_hat_enterprise_linux/7/html/kernel_administration_guide/working_with_sysctl_and_kernel_tunables
https://man7.org/linux/man-pages/man8/sysctl.8.html

#Centos kernel commands
#list of all installed kernels
rpm -q kernel
#remove kernel kernel-3.10.0-327.36.3.el7.x86_64
yum remove kernel-3.10.0-327.36.3.el7.x86_64
#if not installed
yum install yum-utils
#Remove old unused kernel automatically
package-cleanup --oldkernels --count=1



#update kernel on Centos7-8 to 5 ver
#centos7
# https://computingforgeeks.com/install-linux-kernel-5-on-centos-7/
sudo yum -y install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo yum --disablerepo="*" --enablerepo="elrepo-kernel" list available | grep kernel-ml
sudo yum --disablerepo="*" --enablerepo="elrepo-kernel" list available | grep kernel-lt
sudo yum --enablerepo=elrepo-kernel install kernel-ml
sudo yum --enablerepo=elrepo-kernel install kernel-lt
#
sudo awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
sudo grub2-set-default 0
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo reboot
#disconnected
elrepo.org/linux/kernel/el7/x86_64/RPMS
elrepo.org/linux/kernel/el7/x86_64/RPMS/kernel-lt-5.4.197-1.el7.elrepo.x86_64.rpm


# update kernel in Ubuntu 24.04
sudo add-apt-repository ppa:cappelikan/ppa
sudo apt update -y
sudo apt install mainline -y 
sudo mainline # gui interface
