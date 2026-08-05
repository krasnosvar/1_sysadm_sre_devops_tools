terraform {

  #  backend "local" {
  #      path = "terraform.tfstate"
  #  }
  # backend "s3" {
  #   bucket  = "terraform-state-ts-dev-eks"
  #   key     = "terraform.tfstate"
  #   region  = "us-west-2"
  #   profile = ""
  # }
  backend "s3" {
    bucket  = ""
    key     = ""
    region  = ""
    profile = ""
  }


  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.98.0"
    }
  }
}


provider "aws" {
  region  = var.main_vars.aws_region
  profile = var.main_vars.profile
}

resource "aws_s3_bucket" "terraform-state-ts-eks" {
  bucket = "terraform-state-ts-${var.main_vars.required_tags.Env}-eks"
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}
provider "kubernetes" {
  # config_path = "~/.kube/config"
  host                   = aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  exec {
    api_version = "client.authentication.k8s.io/v1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token

  }
}

locals {
  cluster_name = "${var.main_vars.required_tags.Project}-${var.main_vars.required_tags.Platform}-${var.main_vars.required_tags.Env}"
  vpc_name     = "vpc-${var.main_vars.required_tags.Project}-${var.main_vars.required_tags.Platform}-${var.main_vars.required_tags.Env}"
}
