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
