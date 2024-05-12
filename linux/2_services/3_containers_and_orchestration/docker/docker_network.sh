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
