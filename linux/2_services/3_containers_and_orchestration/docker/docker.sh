#INFO
https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/


#add user to docker-group
sudo groupadd docker
sudo usermod -aG docker ${USER}
sudo usermod -aG docker den


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
cd /etc/docker/certs.d/egistry.domain.com/
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
docker pull harbour.corp.domain.ru/dockerhub/krasnosvar-alpinsible2:latest

#make archive from docker image
#images list
$ sudo docker images
REPOSITORY                                                  TAG                 IMAGE ID            CREATED             SIZE
registry.domain.ru/dockerhub/krasnosvar-alpinsible2   latest              62c74a251bed        7 days ago          158MB
#make
sudo docker save --output alpinsible2.tar v00rpm-dr.corp.domain.ru/dockerhub/krasnosvar-alpinsible2
#unpack archive
docker load --input alpinsible2.tar
######################################################

#DOCKER PS
#list only stopped contaainers, only IDs
docker ps -a -q
#or
docker ps --filter "status=exited" | awk 'NR>1{print $1}'
#list only names of running containers
docker ps --format '{{.Names}}'
#check users containers running
docker inspect $(docker ps -q) --format '{{.Config.User}} {{.Name}}'
# List Docker Container Names and IPs
docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Name }}' | sed 's/ \// /'
docker ps -q | xargs -n 1 docker inspect --format '{{ .Name }} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' | sed 's#^/##';


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
#Флаг -q возвращает только численные ID, а флаг -f фильтрует вывод на основе предоставленных условий
docker rm $(docker ps -a -q -f status=exited)
#One liner to stop / remove all of Docker containers:
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
#IMAGES
#remove all images
#Remove all images. 
docker rmi $(docker images -q)
#Deleta all images by name-tag
for i in $(docker images|awk 'NR>1{a=$1":"$2; print a}'); do docker rmi $i; done
#Delete all images by ID
for i in $(docker images|awk 'NR>1{print $3}'); do docker rmi $i; done
#delete docker-images, sorted by "hello-world"
docker images |grep hello-world| for img in $(awk '{print $3}'); do docker rmi $img; done
#CLEAN command in one line
docker stop $(docker ps -a -q) ; \
docker rm $(docker ps -a -q) && \
docker volume rm $(docker volume ls| awk '{print $2}') && \
docker system prune --force && \
for i in $(docker images|awk 'NR>1{print $3}'); do docker rmi -f $i; done

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


#show only stopped containers
docker container ls -f status=exited -a -q
#rm only stopped containers
docker rm $(docker container ls -f status=exited -a -q)

#remove all images which are not used by existing containers
docker image prune -a -f

# show memory usage
docker run -d --name=nginx -p 8081:80 nginx
docker stats --format "table {{.Name}}\t{{.MemUsage}}"
NAME      MEM USAGE / LIMIT
nginx     9.988MiB / 62.66GiB


# count how all containers allocate space (in bytes)
var=0; for i in $(docker inspect -f "{{ .Size }}" $(docker image ls -q)); do var=$((var + $i)); done; echo $var



# DOCKER LOGS
# https://docs.docker.com/config/containers/logging/configure/
docker info --format '{{.LoggingDriver}}'

#узнать где хранятся логи контейнера "alertmanager"
docker inspect --format='{{.LogPath}}' alertmanager


# DOCKER NETWORK
#create new network("bridge by default")
docker network create rbm-24-bridge
#list networks
docker network ls
#remove one network by name
docker network rm mynetwork
#remove all networks
docker network prune
#run container, attached to new network
docker run -d --name rbm-dkr-24-nginx --network rbm-24-bridge nginx:stable
#run alpine, install curl and curl other container by DNS(container name)
docker run -it --rm --name alp-dkr-24 --network rbm-24-bridge alpine:3.10 /bin/ash -c "apk add --update curl && curl -v container_name" 


#netstat, ping, ip in debian-based container
docker exec container_name /bin/bash -c "apt update && apt install net-tools iputils-ping iproute2 curl -y && netstat -ntulp && ping -c 4 db && ip a"
#netstat, ping in alpine-based container
docker exec container_name /bin/ash -c "apk update && apk add ospd-netstat iputils curl && netstat -ntulp"
#telnet(nc) in alpine-based container
docker exec container_name /bin/ash -c "nc db 3306"

#show amount of opened connection by container-port 
#https://cinhtau.net/2018/09/14/check-connections-for-docker-container/
#by specific container
docker inspect -f '{{.State.Pid}}' nginx
nsenter -t 9999 -n netstat -na | grep :443
#all containers
for cont_name in $(docker ps --format '{{.Names}}'); \
do \
dockr_port=$(docker port $cont_name| cut -f1 -d"/"); \
cont_pid=$(docker inspect -f '{{.State.Pid}}' $cont_name); \
echo $cont_name;\
nsenter -t $cont_pid -n netstat -na | grep :$dockr_port| wc -l; done

#check opened ports inside container without netstat
#https://www.commandlinefu.com/commands/view/15313/check-open-ports-without-netstat-or-lsof
declare -a array=($(tail -n +2 /proc/net/tcp | cut -d":" -f"3"|cut -d" " -f"1")) && for port in ${array[@]}; do echo $((0x$port)); done
#or
declare -a array=($(tail -n +2 /proc/net/tcp | cut -d":" -f"3"|cut -d" " -f"1")) && for port in ${array[@]}; do echo $((0x$port)); done | sort | uniq


# DOCKER VOLUMES
#mount NFS directly to container, without mount on host
#https://stackoverflow.com/questions/45282608/how-to-directly-mount-nfs-share-volume-in-container-using-docker-compose-v3

version: "3.2"

services:
  rsyslog:
    image: jumanjiman/rsyslog
    ports:
      - "514:514"
      - "514:514/udp"
    volumes:
      - type: volume
        source: example
        target: /nfs
        volume:
          nocopy: true
volumes:
  example:
    driver_opts:
      type: "nfs"
      o: "addr=10.40.0.199,nolock,soft,rw"
      device: ":/docker/example"



#DOCKER COMPOSE COMMANDS
docker compose -f docker-compose-unmounted.yml up -d
docker compose -f docker-compose-mounted.yml down

#restart only one container(service) "alertmanager" from compose
docker compose -f /var/prometheus/docker-compose_server.yml restart alertmanager


#show running compose containers
docker compose -f /var/prometheus/docker-compose_client.yml ps --services --filter status=running



# DOCKER SWARM
# swarm nodes
docker node ls
docker node ls --filter role=manager

#drain node
docker node update --availability drain node02app
docker node update --availability active node02app

#network
docker network ls

#check service logs
docker service logs
docker service inspect --pretty frontend
docker service ps --no-trunc claim_claim_bp

#service
docker service ls

#move services ( for example on new node) on the fly
for service_name in $(docker service ls | awk '{print $2}'); do docker service update --force $service_name; done

#show all service on all nodes
for service_name in $(docker service ls | awk '{print $2}'); do docker service ps $service_name; done
