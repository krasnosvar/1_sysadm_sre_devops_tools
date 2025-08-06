#KUBECTL
# 1. installing kubectl, alias to "k" and auto completion
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
#2. autocompletion Kubectl in zsh
sudo yum install bash-completion -y
source <(kubectl completion zsh) # in current bash session (bash-completion installed already)
echo "source <(kubectl completion zsh)" >> ~/.zshrc 
echo 'complete -o default -F __start_kubectl k' >>~/.zshrc  
#https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/
#KUBECTL REFERENCE
#https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#label

#HELP kubectl
kubectl --help
kubectl api-resources
kubectl explain pods
#main cluster info show
kubectl get no
kubectl cluster-info 
kubectl config view
# monitoring nodes,pods
kubectl top nodes
kubectl top pods
#list all namespaces
kubectl get namespaces
kubectl get pods --all-namespaces


#show all containers in cluster
#https://kubernetes.io/docs/tasks/access-application-cluster/list-all-running-container-images/#list-container-images-by-pod
kubectl get pods --all-namespaces -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' |sort
#execute commnad "date" on every pod in cluster
for n in $(kubectl get ns| awk 'NR>1{print $1}'); \
do for i in $(kubectl -n $n get po | grep Running| awk '{print $1}'); \
do kubectl -n $n exec $i -- date; done; done 2>/dev/null
#execute commnad "date" on every pod in SPECIFIC NAMESPACE in cluster
nsc=test-ns; for i in $(kubectl -n $nsc get po | grep Running| awk '{print $1}'); do kubectl -n $nsc exec $i -- date; done


#NAMESPACES
#switch to namespace(and not neet to write in in deployments to apply)
kubectl config set-context --current --namespace=trial7d
#delete all from namespace
kubectl delete all --all -n rook-ceph
#delete-create namespace
kubectl delete namespace {namespace}
kubectl create namespace {namespace}



#PODs
# Force replace, delete and then re-create the resource
kubectl replace --force -f ./pod.json
#check on what node is my pod in namespace default
kubectl get pods -o wide -n default
#same for all pods
kubectl get pods -o wide --all-namespaces
#bash into pod
kubectl exec -it podname -- /bin/bash
# delete pods forcefully
for i in $(kubectl get po -n kube-system| grep konnec| awk '{print $1}'); do kubectl delete pod $i --grace-period=0 --force --namespace kube-system; done
# creater pod with argument "--var=vick"
k run podName --image=busybox -- "--var=vick"


#DEPLOYMENTS
#change image
# deployment - frontend
# webapp - container name in the deployment 
kubectl set image deployment/frontend webapp=kodekloud/webapp-color:v2


#SERVICE
# create service via "kubectl expose" command ( for existing pod, or deployment)
# --target-port=80 - pod port to expose
# --name=service-am-i-ready - service name, service will be reacheble from other pods via "curl http://service-am-i-ready:80"
kubectl expose pod am-i-ready --port=80 --target-port=80 --name=service-am-i-ready


#LOGS
#pod logs by label
kubectl logs -l app=krasnosvar_at_gmail.com
#pod logs from all containers constantly
kubectl logs -f first-pod --all-containers=true --tail 10


#get container info(image name) in pod
#json and jq
kubectl get pods -l app=please-set-correct-label -o json | jq .items[].spec.containers[].image
"nginx:1.19.3-alpine"
#go-template
kubectl get pods -l app=please-set-correct-label -o go-template --template="{{range .items}}{{range .spec.containers}}{{.image}} {{end}}{{end}}"
nginx:1.19.3-alpine nginx:1.19.3-alpine nginx:1.19.3-alpine


#working with daemonsets
#label nodes to start pods only on labeled node
kubectl get nodes --show-labels
kubectl label nodes node1, node2 disktype=ssd
#label all nodes
kubectl label nodes --all disktype=ssd


#create resourse by command, not yaml
#create cronjob
kubectl edit cronjob test

# TAINTS and TOLERATIONS
# add taint to node01 with key: apps, value=front and effect of NoSchedule
kubectl taint nodes node01 apps=front:NoSchedule
#check for taints on node
kubectl get nodes -o jsonpath="{range .items[*]}{.metadata.name} {.spec.taints[?(@.effect=='NoSchedule')].effect}{\"\n\"}{end}"
#untaint master-worker nodes
kubectl taint nodes --all node-role.kubernetes.io/master:NoSchedule-


#CONFIGMAPS
#create from CLI
kubectl create configmap my-config --from-literal=key1=value1 --from-literal=key2=value2
#check
kubectl get configmaps my-config -o yaml
#create from file
kubectl create configmap game-config --from-file=myconfig
#grep specific value from configmap ( from all CMs in all NS)
kubectl get cm -o yaml --all-namespaces | grep "what_you_need"


#SECRETS
# get cert from secret
kubectl get secret your-secret-name -n your-namespace -o json | jq '."data"."tls.crt"'| sed 's/"//g'| base64 -d -
#create password as secret
kubectl create secret generic my-password --from-literal=password=mysqlpassword
kubectl create secret generic my-secret --from-literal=key1=supersecret --from-literal=key2=topsecret
#check
kubectl get secret my-password
#create secret for registry auth
kubectl create secret docker-registry regcred --docker-server=hub.docker.local --docker-username=docker_user --docker-password=12345 --docker-email=krasnosvar@gmail.com
#copy secret "wildcard-tls-secret" to another namespace
kubectl get secrets wildcard-tls-secret -n app1 -o json \ 
 | jq 'del(.metadata["namespace","creationTimestamp","resourceVersion","selfLink","uid","annotations"])' \
 | kubectl apply -n gitlab-system -f -



#write manifests to file
for i in $(kubectl get all -n default| grep -v NAME| awk '{print $1}'); do kubectl get $i -o yaml; echo "#######################################"; done > manifests.yml

# LABELS
# https://stackoverflow.com/questions/77301400/how-to-list-all-labels-in-kubernetes
#show all labels
kubectl get all -A --show-labels
# show all, uniq labels
kubectl get all -A -o json | jq -r '.items[].metadata.labels' | sed 's/,//g' | sort | uniq
# fetch resources by label
# https://kubebyexample.com/concept/labels
kubectl get pods --show-labels
kubectl get pods --selector owner=michael
kubectl get pods -l env=development
# list all pods that are either labelled with env=development or with env=production
kubectl get pods -l 'env in (development, production)'


# ERRORS
#if pod stuck in Terminating state
# https://stackoverflow.com/questions/35453792/pods-stuck-in-terminating-status
kubectl delete pod es-kestra-master-0 --grace-period=0 --force --namespace default
for i in $(k0s kubectl get po -n kube-system| grep konnec| awk '{print $1}'); do kubectl delete pod $i --grace-period=0 --force --namespace kube-system; done

#Clean pods ( Error, Completed, NodeShutdown)
for i in $(kubectl -n argocd get po | grep "0/1"| awk '{print $1}'); do kubectl -n argocd delete pod $i; done

#if namespace stuck in terminating state
https://www.redhat.com/sysadmin/troubleshooting-terminating-namespaces
https://stackoverflow.com/questions/52369247/namespace-stuck-as-terminating-how-i-removed-it
