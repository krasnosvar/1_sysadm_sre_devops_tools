# https://www.gateway-api-controller.eks.aws.dev/latest/guides/deploy/#setup
# 1. Install Gateway API CRDs
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.3.0/standard-install.yaml
# 2. Allow traffic from Amazon VPC Lattice
export AWS_REGION=us-west-2
export EKS_CLUSTER_NAME=my-eks-one-az
CLUSTER_SG=$(aws eks describe-cluster --name ${EKS_CLUSTER_NAME} --output json | jq -r '.cluster.resourcesVpcConfig.clusterSecurityGroupId')
# sg-0d8ed878418f51d2f
PREFIX_LIST_ID=$(aws ec2 describe-managed-prefix-lists --query "PrefixLists[?PrefixListName=='com.amazonaws.$AWS_REGION.vpc-lattice'].PrefixListId" | jq -r '.[]')
aws ec2 authorize-security-group-ingress --group-id $CLUSTER_SG --ip-permissions "PrefixListIds=[{PrefixListId=${PREFIX_LIST_ID}}],IpProtocol=-1"
PREFIX_LIST_ID_IPV6=$(aws ec2 describe-managed-prefix-lists --query "PrefixLists[?PrefixListName=='com.amazonaws.$AWS_REGION.ipv6.vpc-lattice'].PrefixListId" | jq -r '.[]')
aws ec2 authorize-security-group-ingress --group-id $CLUSTER_SG --ip-permissions "PrefixListIds=[{PrefixListId=${PREFIX_LIST_ID_IPV6}}],IpProtocol=-1"
# 3. Set up IAM permissions
curl https://raw.githubusercontent.com/aws/aws-application-networking-k8s/main/files/controller-installation/recommended-inline-policy.json -o recommended-inline-policy.json
aws iam create-policy \
    --policy-name VPCLatticeControllerIAMPolicy \
    --policy-document file://recommended-inline-policy.json
export VPCLatticeControllerIAMPolicyArn=$(aws iam list-policies --query 'Policies[?PolicyName==`VPCLatticeControllerIAMPolicy`].Arn' --output text)
# Create the aws-application-networking-system namespace:
curl -o aws-application-networking-system.yaml https://raw.githubusercontent.com/aws/aws-application-networking-k8s/main/files/controller-installation/deploy-namesystem.yaml
kubectl apply -f https://raw.githubusercontent.com/aws/aws-application-networking-k8s/main/files/controller-installation/deploy-namesystem.yaml
# 4. Set up the Pod Identities Agent
# You can choose from Pod Identities (recommended) and IAM Roles For Service Accounts to set up controller permissions.
# https://docs.aws.amazon.com/eks/latest/userguide/pod-id-agent-setup.html
aws eks create-addon --cluster-name ${EKS_CLUSTER_NAME} --addon-name eks-pod-identity-agent --addon-version v1.0.0-eksbuild.1
kubectl get pods -n kube-system | grep 'eks-pod-identity-agent'
# 5. Assign role to Service Account
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
    name: gateway-api-controller
    namespace: aws-application-networking-system
EOF
# Create a trust policy file for the IAM role:
cat > eks-pod-identity-trust-relationship.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowEksAuthToAssumeRoleForPodIdentity",
            "Effect": "Allow",
            "Principal": {
                "Service": "pods.eks.amazonaws.com"
            },
            "Action": [
                "sts:AssumeRole",
                "sts:TagSession"
            ]
        }
    ]
}
EOF
# Create the role:
aws iam create-role --role-name VPCLatticeControllerIAMRole --assume-role-policy-document file://eks-pod-identity-trust-relationship.json --description "IAM Role for AWS Gateway API Controller for VPC Lattice"
aws iam attach-role-policy --role-name VPCLatticeControllerIAMRole --policy-arn=$VPCLatticeControllerIAMPolicyArn
export VPCLatticeControllerIAMRoleArn=$(aws iam list-roles --query 'Roles[?RoleName==`VPCLatticeControllerIAMRole`].Arn' --output text)
# Create the association:
aws eks create-pod-identity-association --cluster-name ${EKS_CLUSTER_NAME} --role-arn ${VPCLatticeControllerIAMRoleArn} --namespace aws-application-networking-system --service-account gateway-api-controller
# 6. Install the Controller
# https://www.gateway-api-controller.eks.aws.dev/latest/guides/deploy/#install-the-controller
kubectl apply -f https://raw.githubusercontent.com/aws/aws-application-networking-k8s/main/files/controller-installation/deploy-v1.1.0.yaml
# Create the amazon-vpc-lattice GatewayClass:
kubectl apply -f https://raw.githubusercontent.com/aws/aws-application-networking-k8s/main/files/controller-installation/gatewayclass.yaml




# rewrite in terraform

# # 1. Install Gateway API CRDs

# provider "kubernetes" {
#   host                   = aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
# }
# # Install Gateway API CRDs via kubectl using a null_resource and local-exec
# # https://www.gateway-api-controller.eks.aws.dev/latest/guides/deploy/#__tabbed_4_1
# resource "null_resource" "gateway_api_install" {
#   provisioner "local-exec" {
#     command = "kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.3.0/standard-install.yaml"
#     environment = {
#       KUBECONFIG = "~/.kube/config"
#     }
#   }
#   depends_on = [aws_eks_cluster.cluster]
# }
############################################################################################
