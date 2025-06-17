data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# cluster
resource "aws_iam_role" "eks_cluster" {
  name               = "${local.cluster_name}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
  tags               = var.main_vars.required_tags
}
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}
resource "aws_eks_cluster" "cluster" {
  name     = local.cluster_name
  version  = var.eks_vars.cluster_version
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    # subnet_ids              = [aws_subnet.private.id]
    subnet_ids              = module.vpc.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
  }
  # update kubeconfig via local-exec provisioner block
  provisioner "local-exec" {
    command = "echo '' > $HOME/.kube/config && aws eks update-kubeconfig --name ${self.name} --region ${var.main_vars.aws_region}"
  }
  tags = var.main_vars.required_tags
}



# node group
# Node group IAM Role
resource "aws_iam_role" "node_group" {
  name               = "${local.cluster_name}-eks-node-group-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume.json
  tags               = var.main_vars.required_tags
}
data "aws_iam_policy_document" "eks_node_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role_policy_attachment" "node_group_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "node_group_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
resource "aws_iam_role_policy_attachment" "node_group_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
resource "aws_eks_node_group" "managed" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${local.cluster_name}-ng"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = module.vpc.private_subnets
  # subnet_ids      = [aws_subnet.private.id, aws_subnet.private2.id]
  instance_types = [var.eks_vars.node_instance_type]
  scaling_config {
    desired_size = var.eks_vars.desired_capacity
    max_size     = var.eks_vars.max_size
    min_size     = var.eks_vars.min_size
  }
  ami_type  = var.eks_vars.ami_type
  disk_size = var.eks_vars.disk_size
  remote_access {
    # ec2_ssh_key = null
    # aws ec2 import-key-pair --key-name my-eks-key --public-key-material fileb://~/.ssh/id_rsa.pub
    ec2_ssh_key = var.eks_vars.ec2_ssh_key
  }
  depends_on = [
    aws_iam_role_policy_attachment.node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.
    node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_group_AmazonEC2ContainerRegistryReadOnly
  ]
  tags = var.main_vars.required_tags
}



# cluster addons
# https://docs.aws.amazon.com/eks/latest/userguide/workloads-add-ons-available-eks.html
# aws --region us-west-2 eks list-addons --cluster-name test-dev-cluster
# check versions
# aws --region us-west-2 eks describe-addon-versions --addon-name amazon-cloudwatch-observability --kubernetes-version 1.33
resource "aws_eks_addon" "addons" {
  for_each                    = { for addon in var.eks_vars.eks_addons : addon.name => addon }
  cluster_name                = local.cluster_name
  addon_name                  = each.value.name
  addon_version               = each.value.version
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on = [
    aws_eks_node_group.managed
  ]
  tags = var.main_vars.required_tags
}
