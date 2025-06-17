### OIDC config
resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = []
  url             = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
  depends_on = [
    aws_eks_node_group.managed
  ]
  tags = var.main_vars.required_tags
}


module "lb_role" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                                = "5.55.0"
  role_name                              = "${local.cluster_name}_eks_lb"
  attach_load_balancer_controller_policy = true
  allow_self_assume_role                 = true
  role_policy_arns = {
    # https://docs.aws.amazon.com/eks/latest/userguide/security-iam-awsmanpol.html#security-iam-awsmanpol-AmazonEKSLoadBalancingPolicy
    AmazonEKSLoadBalancingPolicy = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
  }
  oidc_providers = {
    main = {
      provider_arn               = aws_iam_openid_connect_provider.cluster.arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
  tags = var.main_vars.required_tags
  depends_on = [
    aws_iam_openid_connect_provider.cluster
  ]
}


# data "aws_eks_cluster_auth" "cluster" {}
# provider "kubernetes" {}
resource "kubernetes_service_account" "service-account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
  depends_on = [
    module.lb_role
  ]
}

# provider "helm" {}
resource "helm_release" "alb-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  # check latest ver:
  # helm repo add eks https://aws.github.io/eks-charts
  # helm show chart aws-load-balancer-controller --repo https://aws.github.io/eks-charts
  version   = var.aws_alb_controller_ingress_vars.alb_helm_ver
  namespace = "kube-system"
  depends_on = [
    kubernetes_service_account.service-account
  ]
  set {
    name  = "region"
    value = var.main_vars.aws_region
  }
  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }
  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.${var.main_vars.aws_region}.amazonaws.com/amazon/aws-load-balancer-controller"
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  set {
    name  = "clusterName"
    value = local.cluster_name
  }
}

# https://kubernetes.github.io/ingress-nginx/deploy/#aws
# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# helm repo update ingress-nginx
# helm show chart ingress-nginx --repo https://kubernetes.github.io/ingress-nginx
resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.aws_alb_controller_ingress_vars.ingress_helm_ver
  namespace        = "ingress-nginx"
  create_namespace = true
  timeout          = 300
  values = [
    "${file("./files/ingress_chart_values.yaml")}"
  ]
  set {
    name  = "cluster.enabled"
    value = "true"
  }
  set {
    name  = "metrics.enabled"
    value = "true"
  }
  depends_on = [
    kubernetes_service_account.service-account
  ]
}
