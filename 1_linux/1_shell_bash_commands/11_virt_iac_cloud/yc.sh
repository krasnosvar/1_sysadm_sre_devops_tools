#update yc
yc components update


# Service accounts
#create service account
yc iam service-account create kube-infra
#and add role EDITOR
yc resource-manager folder add-access-binding \
  --name=default \
  --service-account-name=kube-infra \
  --role=editor


#yc create kuber cluster
#first create master
yc managed-kubernetes cluster create \
  --name=kube-infra \
  --public-ip \
  --network-name=default \
  --service-account-name=kube-infra \
  --node-service-account-name=kube-infra \
  --release-channel=rapid \
  --zone=ru-central1-b \
  --security-group-ids=<id security group> \
  --folder-name default 
#then create node-group
yc managed-kubernetes node-group create \
  --name=group-1 \
  --cluster-name=kube-infra \
  --cores=2 \
  --memory=4G \
  --preemptible \
  --auto-scale=initial=1,min=1,max=2 \
  --network-interface=subnets=default-ru-central1-b,ipv4-address=nat,security-group-ids=<id security group> \
  --folder-name default \
  --metadata="ssh-keys=<login>:<pub_key>"
#get KUBECONFIG
yc managed-kubernetes cluster get-credentials --name=kube-infra --external 
#check
kubectl get nodes

