terraform {
  backend "s3" {
    bucket  = "terraform-state-ecr"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = ""
  }
#  backend "local" {
#      path = "terraform.tfstate"
#  }
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    pgp = {
      source = "ekristen/pgp"
      version = "0.2.4"
    }
  }
}


provider "aws" {
  region  = var.aws_region
  profile = var.profile
}

# s3 bucket for state file
resource "aws_s3_bucket" "terraform-state-ecr" {
    bucket = "terraform-rh-state-ecr"
}
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
    bucket = aws_s3_bucket.terraform-state-ecr.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}
resource "aws_s3_bucket_acl" "terraform-state-ecr-acl" {
    depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]

    bucket = aws_s3_bucket.terraform-state-ecr.id
    acl    = "private"
}


# fetch "registry_id"
data "aws_caller_identity" "current" {}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}


resource "aws_ecr_replication_configuration" "rh-aws-docker-registry-replic-conf" {
  replication_configuration {
    rule {
      destination {
        region      = "us-west-2" # dev,qa
        registry_id = data.aws_caller_identity.current.account_id
      }

      ## no need as registry already created in "us-east-1"
      # destination {
      #   region      = "us-east-1" #
      #   registry_id = data.aws_caller_identity.current.account_id
      # }
    }
  }
}


module "ecr" {
  source                = "./modules/ecr"
  for_each              = var.repositories
  name                  = each.value
  image_tag_mutability  = var.image_tag_mutability
  scan_on_push          = var.scan_on_push
  additional_tags       = var.additional_tags
}



# ECR user for deploy pull-push images
# https://medium.com/@mkhanops/creating-an-ecr-user-for-secure-docker-image-push-488f7ac32c8b
# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEC2ContainerRegistryPowerUser.html
resource "aws_iam_user_policy" "ecr-user-policy" {
  name   = "ecr_user_policy"
  user   = aws_iam_user.ecr-user.name
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:ListTagsForResource",
        "ecr:DescribeImageScanFindings",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ],
      "Resource" : "*"
    }
  ]
})
}

# https://stackoverflow.com/questions/70363655/creating-iam-user-with-change-password-on-login-option-using-terraform
# https://stackoverflow.com/a/70375150
resource "pgp_key" "ecr-user" {
  name    = "ecr-user"
  email   = "ecr-user@nomail.com"
  comment = "ecr-user"
}

resource "aws_iam_user" "ecr-user" {
  name = "service-ecr-user"
  path = "/"
}

resource "aws_iam_user_login_profile" "ecr-user" {
  user                    = aws_iam_user.ecr-user.name
  pgp_key                 = pgp_key.ecr-user.public_key_base64
  password_reset_required = false
}

resource "aws_iam_access_key" "ecr-user" {
  user    = aws_iam_user.ecr-user.name
  pgp_key = pgp_key.ecr-user.public_key_base64
}

data "pgp_decrypt" "ecr-user-pass" {
  private_key         = pgp_key.ecr-user.private_key
  ciphertext          = aws_iam_user_login_profile.ecr-user.encrypted_password
  ciphertext_encoding = "base64"
}

data "pgp_decrypt" "ecr-user-access-key" {
  private_key         = pgp_key.ecr-user.private_key
  ciphertext          = aws_iam_access_key.ecr-user.encrypted_secret
  ciphertext_encoding = "base64"
}



# terraform output password-ecr-user
output "password-ecr-user" {
  value     = data.pgp_decrypt.ecr-user-pass.plaintext
  sensitive = true
}

# terraform output access-key-ecr-user
output "access-key-ecr-user" {
  value     = data.pgp_decrypt.ecr-user-access-key.plaintext
  sensitive = true
}
