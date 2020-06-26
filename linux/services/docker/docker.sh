#add user to docker-group
sudo usermod -aG docker ${USER}


#v00rpm-dr.corp.domain.ru - docker registry
#copy docker image to our local registry:
#https://rundeck.corp.domain.ru/project/domainGK >>> add_docker_image
krasnosvar/alpinsible2:latest

#Создать образ 
#BUILD
#-t тэг образа
docker build  -t dkr-16:1.0 .
docker build  -t dkr-16:latest .
#create(build) image from directory "docker" from Dockerfile "prod"
docker build --file ./docker/prod .
#если Dockerfile файл мультистейж- сделать сборку только определеного образа "grafana" из Dockerfile
docker build --target grafana -t grafana:app .

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
######################################################

#DOCKER PS
#list only stopped contaainers, only IDs
docker ps --filter "status=exited" | awk 'NR>1{print $1}'


#attach to running container
docker exec -it CONTAINER_ID /bin/bash
#по ID контейнера выполнить команду внутри контейнера
for i in $(docker ps|awk '{print $1}'); do docker exec $1 /bin/sh -c 'grep -ri "8.8.8.8"'; done

#Docker никогда не удаляет data volumes, даже если контейнеры, которые их создали, удалены.
#Для того чтобы посмотреть список осиротевших томов, используйте команду:
docker volume ls -qf dangling=true

#Для удаления таких томов:
docker volume rm $(docker volume ls -qf dangling=true)

#CLEAN
#Эта команда удаляет все контейнеры, у которых статус exited. 
Флаг -q возвращает только численные ID, а флаг -f фильтрует вывод на основе предоставленных условий
docker rm $(docker ps -a -q -f status=exited)
#One liner to stop / remove all of Docker containers:
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
#IMAGES
#remove all images
Remove all images. docker rmi $(docker images -q)
#Deleta all images by name-tag
for i in $(docker images|awk 'NR>1{a=$1":"$2; print a}'); do docker rmi $i; done
#Delete all images by ID
for i in $(docker images|awk 'NR>1{print $3}'); do docker rmi $i; done
#delete docker-images, sorted by "hello-world"
docker images |grep hello-world| for img in $(awk '{print $3}'); do docker rmi $img; done
#CLEAN command in one line
docker stop $(docker ps -a -q) ; \
docker rm $(docker ps -a -q) && \
docker system prune --force && \
for i in $(docker images|awk 'NR>1{print $3}'); do docker rmi $i; done

#TAG
#rename image with new tag( for pushing to registry, for example)
docker tag dkr21:dockerignore registry.com/krasnosvar/fat_free_crm-dkr-20:dockerignore


#REStart Policy
#all four restart policies(without "--restart" - do not apply any restart policy)
docker run -d -p 81:80 --name bm-dkr-22-no nginx:stable-alpine
docker run -d --restart on-failure -p 82:80 --name bm-dkr-22-on-failure nginx:stable-alpine
docker run -d --restart always -p 83:80 --name bm-dkr-22-always nginx:stable-alpine
docker run -d --restart unless-stopped -p 84:80 --name bm-dkr-22-unless-stopped nginx:stable-alpine
#start only stopped containers
for i in $(docker ps --filter "status=exited" | awk 'NR>1{print $1}'); do docker start $i; done
#stop all running containers
docker stop $(docker ps -aq)
