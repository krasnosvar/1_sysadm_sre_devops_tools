snap install kubectl --classic
apt install jq

##https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-api/
kubectl proxy --port=8080 &
curl http://localhost:8080/api/

#https://gist.github.com/mcastelino/9baf1979f337f63f8bb98463166962d2
curl -s http://localhost:8080/api/v1/nodes| jq '.items[].metadata.labels'

curl -s http://localhost:8080/api/v1/namespaces| jq '.items[].metadata.name'
curl -s http://localhost:8080/api/v1/namespaces/default| jq
curl -s http://localhost:8080/api/v1/pods| jq '.items[].metadata.name'
curl -s http://localhost:8080/api/v1/pods| jq '.items[].metadata.selfLink'
curl -s http://localhost:8080/api/v1/namespaces/kube-system/pods/etcd-minikube01|jq

#curl deployment
#https://v1-16.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#-strong-write-operations-deployment-v1-apps-strong-
curl -X POST -H "Content-Type: application/json" --data @ex8.json http://127.0.0.1:8808/apis/apps/v1/namespaces/default/deployments
