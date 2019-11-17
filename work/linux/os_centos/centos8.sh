#install ansible on centos8
#Add EPEL repository to your CentOS 8 / RHEL 8 system.
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
#Then Enable EPEL playground repository and install Ansible on CentOS 8 / RHEL 8 from it.
sudo dnf install  --enablerepo epel-playground  ansible
#Method 2: Install Ansible on CentOS 8 / RHEL 8 using pip
pip3 install ansible --user
#or
pip2 install ansible --user


#NGINX
dnf install nginx
systemctl start nginx
systemctl enable nginx
#Open HTTP firewall port 80
firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --reload
#allow https
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --reload
