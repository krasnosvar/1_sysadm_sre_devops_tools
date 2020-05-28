#USERS
#make user krasnosvarov_dn cluster-admin
oc adm add-cluster-role cluster-admin krasnosvarov_dn
oc adm policy add-cluster-role-to-user cluster-admin krasnosvarov_dn


#WORK WITH REGISTRY
#add registry to cluster
podman login registry.ru --tls-verify=false

#CLUSTER
#login to cluster from bastion
oc login --token=token_from_web --server=https://api.ocp4.cluster.ru:6443

#PROJECT
#create new project
oc new-progect kras

