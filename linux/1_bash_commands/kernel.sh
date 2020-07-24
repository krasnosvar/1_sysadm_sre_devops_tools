#Centos kernel commands

#list of all installed kernels
rpm -q kernel

#remove kernel kernel-3.10.0-327.36.3.el7.x86_64
yum remove kernel-3.10.0-327.36.3.el7.x86_64

#if not installed
yum install yum-utils

#Remove old unused kernel automatically
package-cleanup --oldkernels --count=1
