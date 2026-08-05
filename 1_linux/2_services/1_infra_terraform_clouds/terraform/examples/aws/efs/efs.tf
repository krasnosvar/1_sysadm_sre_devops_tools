# https://docs.aws.amazon.com/efs/latest/ug/wt1-getting-started.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system
# Step 2.1: Create an EFS file system
# Step 2.2: Enable lifecycle management
# Step 2.3: Create a mount target


resource "aws_efs_file_system" "efs_fs" {
  creation_token = "efs-${var.required_tags.Platform}"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags       = var.required_tags
  depends_on = [module.vpc]
}
resource "aws_efs_access_point" "efs_ap" {
  file_system_id = aws_efs_file_system.efs_fs.id
}


# # no need IAM if we use only standart nfs-utils (and not use amazon's "efs-utils")
# data "aws_iam_policy_document" "efs_iam_policy" {
#   statement {
#     sid    = "ExampleStatement01"
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }

#     actions = [
#       "elasticfilesystem:ClientMount",
#       "elasticfilesystem:ClientWrite",
#       "elasticfilesystem:ClientRootAccess",
#     ]

#     resources = [aws_efs_file_system.efs_fs.arn]

#     condition {
#       test     = "Bool"
#       variable = "aws:SecureTransport"
#       values   = ["true"]
#     }
#   }
# }

# resource "aws_efs_file_system_policy" "efs_policy" {
#   file_system_id = aws_efs_file_system.efs_fs.id
#   policy         = data.aws_iam_policy_document.efs_iam_policy.json
# }

resource "aws_efs_mount_target" "efs_mt" {
  for_each       = toset(module.vpc.private_subnets)
  file_system_id = aws_efs_file_system.efs_fs.id
  subnet_id      = each.key
  # by default - adds "default sg", we need to set our sg's manually
  security_groups = toset([module.security-group.security_group_id]) # or Inappropriate value for attribute "security_groups": set of string required.
}


# outputs
output "efs_file_system_id" {
  description = "The ID of the EFS file system"
  value       = aws_efs_file_system.efs_fs.id
}

output "efs_file_system_arn" {
  description = "The ARN of the EFS file system"
  value       = aws_efs_file_system.efs_fs.arn
}

output "efs_access_point_id" {
  description = "id EFS access point"
  value       = aws_efs_access_point.efs_ap.id
}

output "efs_access_point_arn" {
  description = "arn EFS access point"
  value       = aws_efs_access_point.efs_ap.arn
}

output "efs_mount_target_ip_addresses" {
  description = "List of EFS Mount Target IP Addresses"
  value = { for k, mt in aws_efs_mount_target.efs_mt : k => mt.ip_address }
}

output "efs_mount_target_dns_names" {
  description = "List of EFS Mount Target DNS Names"
  value = {
    for k, mt in aws_efs_mount_target.efs_mt :
    k => "${aws_efs_file_system.efs_fs.id}.efs.${var.aws_region}.amazonaws.com"
  }
}
