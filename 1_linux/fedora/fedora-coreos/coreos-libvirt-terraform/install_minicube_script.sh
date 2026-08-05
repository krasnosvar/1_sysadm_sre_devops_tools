for i in $(for i in $(virsh list|tail -n+3|awk '{print $2}'); do virsh domifaddr $i|grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'; done)
do 
ssh core@$i "curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube"
ssh core@$i "sudo mkdir -p /usr/local/bin/"
ssh core@$i "sudo install minikube /usr/local/bin/"
ssh den@$i "minikube start --driver=podman"
done
