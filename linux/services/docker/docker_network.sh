#create new network("bridge by default")
docker network create rbm-24-bridge
#list networks
docker network ls
#run container, attached to new network
docker run -d --name rbm-dkr-24-nginx --network rbm-24-bridge nginx:stable
#run alpine, install curl and curl other container by DNS(container name)
docker run -it --rm --name alp-dkr-24 --network rbm-24-bridge alpine:3.10 /bin/ash -c "apk add --update curl && curl -v rbm-dkr-24-nginx" 
