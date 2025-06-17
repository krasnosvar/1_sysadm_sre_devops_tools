# output "eks_cluster_endpoint" {
#   value = aws_eks_cluster.cluster.endpoint
# }

# output "eks_cluster_name" {
#   value = aws_eks_cluster.cluster.name
# }



# aws eks update-kubeconfig --name test-dev-cluster --region us-west-2
# terraform output -raw kubeconfig > kubeconfig
# # KUBECONFIG=./kubeconfig kubectl get nodes
# output "kubeconfig" {
#   description = "Kubeconfig for this EKS cluster"
#   value       = <<EOF
# apiVersion: v1
# clusters:
# - cluster:
#     server: ${aws_eks_cluster.cluster.endpoint}
#     certificate-authority-data: ${aws_eks_cluster.cluster.certificate_authority[0].data}
#   name: ${aws_eks_cluster.cluster.name}
# contexts:
# - context:
#     cluster: ${aws_eks_cluster.cluster.name}
#     user: aws
#   name: ${aws_eks_cluster.cluster.name}
# current-context: ${aws_eks_cluster.cluster.name}
# kind: Config
# preferences: {}
# users:
# - name: aws
#   user:
#     exec:
#       apiVersion: "client.authentication.k8s.io/v1beta1"
#       command: "aws"
#       args:
#         - "eks"
#         - "get-token"
#         - "--cluster-name"
#         - "${aws_eks_cluster.cluster.name}"
#         - "--region"
#         - "${var.main_vars.aws_region}"
# EOF
# }
