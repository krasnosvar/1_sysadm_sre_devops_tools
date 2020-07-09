#https://linuxconfig.org/how-to-install-jenkins-on-ubuntu-20-04-focal-fossa-linux
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
#https://linuxconfig.org/ubuntu-20-04-gpg-error-the-following-signatures-couldn-t-be-verified
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 9B7D32F2D50582E6
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update -y

ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""

sudo apt install openjdk-11-jdk-headless -y
sudo apt install jenkins -y
sudo systemctl enable --now jenkins
sudo ufw allow 8080 

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

#PLUGINS
#https://www.phpflow.com/misc/devops/how-to-manually-install-jenkins-plugin/
