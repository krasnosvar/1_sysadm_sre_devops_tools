#v00rpm-dr.corp.domain.ru - docker registry
#copy docker image to our local registry:
#https://rundeck.corp.domain.ru/project/domainGK >>> add_docker_image
krasnosvar/alpinsible2:latest

#Создать образ для Харбора и запулить в регистри
docker build -t v00rpm-dr.corp.domain.ru/dockerhub/docker-hello-world:latest .
docker login v00rpm-dr.corp.domain.ru/dockerhub/
docker push v00rpm-dr.corp.domain.ru/dockerhub/docker-hello-world:latest

#install docker 
wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce-cli_18.09.6~3-0~ubuntu-bionic_amd64.deb --no-check-certificate
wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce_18.09.6~3-0~ubuntu-bionic_amd64.deb --no-check-certificate
dpkg -i docker-ce_18.09.6~3-0~ubuntu-bionic_amd64.deb 
dpkg -i docker-ce-cli_18.09.6~3-0~ubuntu-bionic_amd64.deb docker-ce_18.09.6~3-0~ubuntu-bionic_amd64.deb 

##############################################
if "x509: certificate signed by
unknown authority" error:

1.fetch cert from registry(by firefox)
openssl s_client -showcerts -connect registry.domain.com:443 </dev/null 2>/dev/null|openssl x509 -outform PEM >ca.crt
2.copy to:
(if not exist- mkdir)
cd /etc/docker/certs.d/v00rpm-dr.corp.domain.ru/
3. rename to ca.crt

##############################################
#make user glinomes sudoer:
adduser glinomes
usermod -a -G docker glinomes
docker run --rm -it -v /etc/sudoers.d:/etc/sudoers.d cdf98d1859c1
/ # cd /etc/sudoers.d/
/etc/sudoers.d # ls
/etc/sudoers.d # echo "glinomes    ALL=(ALL:ALL) ALL" > glinomes
/etc/sudoers.d # chmod 0440 glinomes 
/etc/sudoers.d # exit
sudo su

######################################################
#pull image froum internal docker-registry (Harbour)
docker pull v00rpm-dr.corp.domain.ru/dockerhub/krasnosvar-alpinsible2:latest

#make archive from docker image
#images list
den@it-krasnosvarov:~$ sudo docker images
REPOSITORY                                                  TAG                 IMAGE ID            CREATED             SIZE
v00rpm-dr.corp.domain.ru/dockerhub/krasnosvar-alpinsible2   latest              62c74a251bed        7 days ago          158MB
#make
sudo docker save --output alpinsible2.tar v00rpm-dr.corp.domain.ru/dockerhub/krasnosvar-alpinsible2
#unpack archive
docker load --input alpinsible2.tar

#add user to docker-group
sudo usermod -aG docker ${USER}

#One liner to stop / remove all of Docker containers:
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

#delete docker-images, sorted by "hello-world"
docker images |grep hello-world| for img in $(awk '{print $3}'); do docker rmi $img; done


#attach to a container
docker exec -it CONTAINER_ID /bin/bash
#по ID контейнера выполнить команду внутри контейнера
for i in $(docker ps|awk '{print $1}'); do docker exec $1 /bin/sh -c 'grep -ri "8.8.8.8"'; done
