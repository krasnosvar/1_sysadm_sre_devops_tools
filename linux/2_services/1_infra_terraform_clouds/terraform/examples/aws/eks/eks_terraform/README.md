#### README EKS infra setup
1. EKS via terraform

```
This creates:
- VPC( via module), subnets, routing, NAT (for private subnet internet)
- IAM role for EKS control plane, EKS cluster, node group to run workloads ( with addons )
- AWS LB controller + Ingress controller
```

* fully parametrizied via tfvars
* run shell script with Env as argument
* create:
```
./apply_env_tf_wrapper.sh dev
```

* delete:
```
./destroy_env_tf_wrapper.sh dev
```

* docs
* https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html
* EKS cluster Prerequisites
* https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html#_prerequisites









2. FOR FUTURE SETUPS
* Kubernetes Gateway API ( in k8s - instead of Ingress)
```
 aws
* https://www.gateway-api-controller.eks.aws.dev/latest/concepts/concepts/
* https://github.com/aws/aws-application-networking-k8s

* k8s
* https://gateway-api.sigs.k8s.io/implementations/
```
* ArgoCD



3. useful CMMDs
```
# import ssh pub key for eks-nodes access 
aws ec2 import-key-pair --key-name my-eks-key --public-key-material fileb://~/.ssh/id_rsa.pub

# refresh kubeconfig
aws eks update-kubeconfig --name eks-eks-dev --region us-west-2

# list installed addons
aws eks list-addons --cluster-name test-dev-cluster

ALB logs
kubectl logs -f -n kube-system -l app.kubernetes.io/instance=aws-load-balancer-controller

fetch oidc url
aws --region us-west-2 eks describe-cluster --name my-eks-one-az --query "cluster.identity.oidc.issuer" --output text
```

* troubleshoot helm
```
helm -n ingress-nginx status ingress-nginx
kubectl get service --namespace ingress-nginx ingress-nginx-controller --output wide --watch
kubectl -n ingress-nginx get events --sort-by='.lastTimestamp'  
k -n ingress-nginx logs ingress-nginx-admission-create-lwmcd  
```
