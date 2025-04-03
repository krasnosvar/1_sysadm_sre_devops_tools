terraform {
  backend "s3" {
    bucket  = "terraform-state-remote-in-s3"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "profile-name-for-creds"
  }
  #  backend "local" {
  #      path = "terraform.tfstate"
  #  }
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    # for iam user 
    pgp = {
      source  = "ekristen/pgp"
      version = "0.2.4"
    }
  }
}


provider "aws" {
  region  = var.aws_region
  profile = var.profile
}


# ECR user for deploy pull-push images
# https://medium.com/@mkhanops/creating-an-ci-cd-user-for-secure-docker-image-push-488f7ac32c8b
# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEC2ContainerRegistryPowerUser.html
resource "aws_iam_user_policy" "ci-cd-user-policy" {
  name = "ci_cd_user_policy"
  user = aws_iam_user.ci-cd-user.name
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:StartInstances",
                "ec2:StopInstances"
            ],
            "Resource": "arn:aws:ec2:*:*:instance/*",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/Env": "dev"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "ec2:DescribeInstances",
            "Resource": "*"
        }
    ]
  })
}


# https://www.reddit.com/r/Terraform/comments/t9jcms/aws_iam_user_with_password_access_and_secret_keys/
# https://stackoverflow.com/questions/70363655/creating-iam-user-with-change-password-on-login-option-using-terraform
# https://stackoverflow.com/a/70375150
resource "pgp_key" "ci-cd-user" {
  name    = "ci-cd-user"
  email   = "ci-cd-user@nomail.com"
  comment = "ci-cd-user"
}

resource "aws_iam_user" "ci-cd-user" {
  name = "service-ci-cd-user"
  path = "/"
}

resource "aws_iam_user_login_profile" "ci-cd-user" {
  user                    = aws_iam_user.ci-cd-user.name
  pgp_key                 = pgp_key.ci-cd-user.public_key_base64
  password_reset_required = false
}

resource "aws_iam_access_key" "ci-cd-user" {
  user    = aws_iam_user.ci-cd-user.name
  pgp_key = pgp_key.ci-cd-user.public_key_base64
}

data "pgp_decrypt" "ci-cd-user-pass" {
  private_key         = pgp_key.ci-cd-user.private_key
  ciphertext          = aws_iam_user_login_profile.ci-cd-user.encrypted_password
  ciphertext_encoding = "base64"
}

data "pgp_decrypt" "ci-cd-user-access-key" {
  private_key         = pgp_key.ci-cd-user.private_key
  ciphertext          = aws_iam_access_key.ci-cd-user.encrypted_secret
  ciphertext_encoding = "base64"
}



# terraform output password-ci-cd-user
output "password-ci-cd-user" {
  value     = data.pgp_decrypt.ci-cd-user-pass.plaintext
  sensitive = true
}

output "aws_access_key_id" {
  value     = aws_iam_access_key.ci-cd-user.id
  sensitive = false
}

# terraform output access-key-ci-cd-user
output "aws_secret_access_key" {
  value     = data.pgp_decrypt.ci-cd-user-access-key.plaintext
  sensitive = true
}


# terraform output aws_access_key_id
# terraform output aws_secret_access_key
