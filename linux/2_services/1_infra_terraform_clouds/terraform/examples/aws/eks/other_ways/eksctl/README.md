#### Create cluster with ```eksctl```


1. Install ```eksctl```
* https://eksctl.io/installation/


2. Create IAM role + role policy ( or attach default)
* https://docs.aws.amazon.com/eks/latest/userguide/cluster-iam-role.html#create-service-role
* https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKSClusterPolicy.html


3. Create cluster config - YAML
* https://eksctl.io/usage/schema/


4. create cluster
```
eksctl create cluster -f cluster.yaml
```


* pretty output cli util:
* [eksdemo](https://github.com/awslabs/eksdemo)
```
# check IAMs
eksdemo --region us-west-2 -c ts-oms-eks-dev get access-entry 


# list network interfaces
eksdemo --region us-west-2 -c ts-oms-eks-dev get network-interface
```


#### Install AWS ALB controller in EKS cluster
* https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html

1. Download and apply policy for AWS ALB-controller via eksctl
```
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.13.0/docs/install/iam_policy.json


aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json


eksctl create iamserviceaccount \
    --cluster=test-dev-cluster \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::5...1:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --region us-west-2 \
    --approve


```

2. Install AWS Load Balancer Controller
```
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks


helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=test-dev-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --version 1.13.2


k -n kube-system get deploy aws-load-balancer-controller
```

3. USE using the controller to provision AWS resources
* https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html
* https://docs.aws.amazon.com/eks/latest/userguide/network-load-balancing.html

