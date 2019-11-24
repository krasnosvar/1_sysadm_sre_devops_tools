#install ansible on centos8
#Add EPEL repository to your CentOS 8 / RHEL 8 system.
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
#Then Enable EPEL playground repository and install Ansible on CentOS 8 / RHEL 8 from it.
sudo dnf install  --enablerepo epel-playground  ansible
#Method 2: Install Ansible on CentOS 8 / RHEL 8 using pip
pip3 install ansible --user
#or
pip2 install ansible --user


#enable network on boot
sudo systemctl enable NetworkManager.service


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

#DOCKER_KUBER
#install docker on centos8
#https://linuxconfig.org/how-to-install-docker-in-rhel-8
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

   15  setenforce 0
   16  sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

   19  swapoff -a
   21  yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
   22  yum install docker-ce
   23  sudo yum install -y yum-utils   device-mapper-persistent-data   lvm2
   24  sudo yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo
#    25  sudo yum install docker-ce docker-ce-cli containerd.io -y
#    26  sudo dnf repolist -v
   27  dnf list docker-ce --showduplicates | sort -r
   28  sudo dnf install docker-ce-3:18.09.1-3.el7
###################################################################################
