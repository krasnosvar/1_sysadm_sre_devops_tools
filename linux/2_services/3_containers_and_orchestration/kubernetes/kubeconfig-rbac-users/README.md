check roles in cluster
k get role --all-namespaces



<!-- https://kubernetes.io/docs/reference/kubectl/generated/kubectl_auth/kubectl_auth_can-i/ -->
# list permissions
kubectl auth can-i --list --namespace=default --as dev-user

kubectl auth can-i list pods --namespace=default --as dev-user

 # Check to see if I can read pod logs
  kubectl auth can-i get pods --subresource=log


kubectl auth can-i create deployments/ --namespace=blue --as dev-user
