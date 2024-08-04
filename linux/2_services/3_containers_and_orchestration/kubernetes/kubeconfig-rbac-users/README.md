check roles in cluster
k get role --all-namespaces


1. Check location of kubeconfig
```
k get po -v=6

I0804 08:56:09.779146    3814 loader.go:395] Config loaded from file:  /root/.kube/config
...
```


<!-- https://kubernetes.io/docs/reference/kubectl/generated/kubectl_auth/kubectl_auth_can-i/ -->
# list permissions
kubectl auth can-i --list --namespace=default --as dev-user

kubectl auth can-i list pods --namespace=default --as dev-user

 # Check to see if I can read pod logs
  kubectl auth can-i get pods --subresource=log


kubectl auth can-i create deployments/ --namespace=blue --as dev-user
