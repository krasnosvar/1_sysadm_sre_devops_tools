#MINICUBE
minikube start
minikube dashboard
#use local Dockerfile with minikube
#https://stackoverflow.com/questions/42564058/how-to-use-local-docker-images-with-minikube
# Start minikube
minikube start
# Set docker env
eval $(minikube docker-env)
# Build image
docker build -t ubuntu:k8s-4 .
# Run in minikube
kubectl run pod-k8s-4 --image=ubuntu:k8s-4 --image-pull-policy=Never
# Check that it's running
kubectl get pods
---------------------------------------------------------------------------------------
###### . Установка docker и minicube(локально, без VM) на Centos8
* https://www.linuxtechi.com/install-kubernetes-k8s-minikube-centos-8/
#update and disable selinux
dnf update -y
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
#install docker
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install docker-ce --nobest -y
systemctl start docker
systemctl enable docker
#disable firewall(in Centos8-DO-droplets not installed)
firewall-cmd --zone=public --add-masquerade --permanent
firewalld --zone=public --add-masquerade --permanent
#install kubectl
dnf install conntrack -y
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl version --client
#install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
mkdir -p /usr/local/bin/
install minikube /usr/local/bin/
#start minikube
minikube start --driver=none
snap install kubectl --classic
---------------------------------------------------------------------------------------
#minikube remote kubectl
scp -r den@192.168.122.63:/home/den/.kube $HOME/
kubectl get no


#run demo-pod and expose its 8888 port to 9999 on host
kubectl run demo --image=cloudnatived/demo:hello --port=9999 --labels app=demo
kubectl port-forward deploy/demo 9999:8888


#remote dashboard open in browser
#https://stackoverflow.com/questions/47173463/how-to-access-local-kubernetes-minikube-dashboard-remotely
kubectl proxy --address='0.0.0.0' --disable-filter=true
curl http://192.168.122.254:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/



#NETWORK
#add external ip to service
kubectl patch svc keycloak -n default -p '{"spec": {"type": "LoadBalancer", "externalIPs":["192.168.122.179"]}}'


#old version 
minikube start --kubernetes-version=v1.20.0
