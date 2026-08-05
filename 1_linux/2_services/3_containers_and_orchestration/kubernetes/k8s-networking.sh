# check pod cidr
kubectl get no node01 -o json| grep -i pod
# or with jq
kubectl get no node01 -o json | jq '.spec.podCIDR'


#check services ip-range
ps aux| grep kube-apiserver|  grep service-cluster-ip-range


# check what type of kube-roxy used
# https://medium.com/@seifeddinerajhi/kube-proxy-and-cni-the-hidden-components-of-kubernetes-networking-eb30000bf87a
curl -v localhost:10249/proxyMode

