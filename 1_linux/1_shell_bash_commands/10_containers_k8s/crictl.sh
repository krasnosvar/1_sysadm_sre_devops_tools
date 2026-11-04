#CRICTL - debug containers on k8s node directly via CRI (containerd/CRI-O)
# when kubectl/apiserver is unavailable or to see what kubelet really runs
sudo crictl --runtime-endpoint unix:///run/containerd/containerd.sock ps
# or set once in /etc/crictl.yaml:
# runtime-endpoint: unix:///run/containerd/containerd.sock

sudo crictl pods
sudo crictl pods --name NAME --namespace NS
sudo crictl ps -a                     # include exited containers
sudo crictl logs --tail 100 CONTAINER_ID
sudo crictl logs -p CONTAINER_ID      # previous instance
sudo crictl exec -it CONTAINER_ID sh
sudo crictl inspect CONTAINER_ID | jq '.info.pid'
sudo crictl inspectp POD_ID
sudo crictl stats
sudo crictl images
sudo crictl pull nginx:stable
sudo crictl rmi --prune               # remove unused images

#containerd native cli (namespace k8s.io)
sudo ctr -n k8s.io containers list
sudo ctr -n k8s.io images list
