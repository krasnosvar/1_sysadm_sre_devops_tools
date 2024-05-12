# https://habr.com/ru/companies/otus/articles/790710/
helm search hub — search all charts in Artifact Hub.
helm search hub wordpress
helm search repo — search in local repos(added by -  helm repo add).
helm install <release name> <chart name>


https://helm.sh/docs/chart_template_guide/getting_started/



# universal cmd to install, upgrade and create namespace for repo if not exist
helm upgrade local-chart  --install ./29_repo/ --namespace helm --create-namespace

#show configured manifests from templates
helm template local-chart  ./29_repo/

#install chert
helm install local-chart ./29_repo/ --namespace helm --create-namespace

#if error
helm delete local-chart--purge ./29_repo/ --namespace helm

#list installed helms in all namespaces
helm list -A
#or in specific
helm list  --namespace helm  

#show installed revisions
helm history local-chart  --namespace helm

#rollback to rev.1
helm rollback local-chart 1 --namespace helm



#helm order to up resources
var InstallOrder SortOrder = []string{
	"Namespace",
	"ResourceQuota",
	"LimitRange",
	"PodSecurityPolicy",
	"Secret",
	"ConfigMap",
	"StorageClass",
	"PersistentVolume",
	"PersistentVolumeClaim",
	"ServiceAccount",
	"CustomResourceDefinition",
	"ClusterRole",
	"ClusterRoleBinding",
	"Role",
	"RoleBinding",
	"Service",
	"DaemonSet",
	"Pod",
	"ReplicationController",
	"ReplicaSet",
	"Deployment",
	"StatefulSet",
	"Job",
	"CronJob",
	"Ingress",
	"APIService",
}

# workaround to reporder up
# https://stackoverflow.com/questions/59653816/helm-install-in-specific-order-for-deployment
# You could set annotations: Pre-install hook with hook-weight like in this example (lower value in hook-weight have higher priority). 

apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  annotations:
    helm.sh/hook: pre-install
    helm.sh/hook-weight: "10"
