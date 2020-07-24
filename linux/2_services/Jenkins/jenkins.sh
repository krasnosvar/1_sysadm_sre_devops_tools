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
###############################################################
#install in docker
#!/bin/bash
sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update -y
sudo apt install nginx docker-ce -y

docker network create jenkins
docker volume create jenkins-docker-certs
docker volume create jenkins-data

docker container run --name jenkins-docker --rm --detach \
  --privileged --network jenkins --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --volume "$HOME":/home \
  --publish 3000:3000 docker:dind

docker container run --name jenkins-blueocean --rm --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  --volume "$HOME":/home \
  --publish 8080:8080 jenkinsci/blueocean

sleep 30
docker exec jenkins-blueocean /bin/bash -c 'cat /var/jenkins_home/secrets/initialAdminPassword'
###############################################################


#PLUGINS
#https://www.phpflow.com/misc/devops/how-to-manually-install-jenkins-plugin/
https://updates.jenkins-ci.org/download/plugins/

#BUILD-IN-VARS
http://192.168.122.240:8080/env-vars.html/
