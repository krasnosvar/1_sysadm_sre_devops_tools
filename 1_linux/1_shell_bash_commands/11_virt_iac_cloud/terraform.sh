# Terraform CLI reference
# Docs: https://developer.hashicorp.com/terraform/cli
# OpenTofu (OSS fork, drop-in replacement): https://opentofu.org/docs/cli/

# ── Core workflow ─────────────────────────────────────────────────────────────
terraform init                          # download providers + modules
terraform init -upgrade                 # upgrade providers to latest allowed versions
terraform init -migrate-state           # switch backends (e.g. local → S3)
terraform init -reconfigure             # re-init without migrating state

terraform validate                      # check HCL syntax and types
terraform fmt                           # canonical formatting (align = signs, indents)
terraform fmt -recursive                # format all .tf files recursively
terraform fmt -check                    # exit 1 if files need formatting (CI)

terraform plan                          # show what will change
terraform plan -out=tfplan              # save plan to file (use in CI to avoid drift)
terraform plan -refresh-only            # show drift without changing anything
terraform plan -target=aws_instance.web # plan only one resource

terraform apply                         # apply changes (prompts for confirmation)
terraform apply -auto-approve           # skip confirmation (CI)
terraform apply tfplan                  # apply saved plan file
terraform apply -replace=aws_instance.web  # force replace (was: taint)
terraform apply -target=aws_instance.web   # apply only one resource
terraform apply -var="env=prod"         # pass variable on CLI
terraform apply -var-file=prod.tfvars   # pass variables from file

terraform destroy                       # destroy all resources
terraform destroy -target=aws_s3_bucket.old  # destroy one resource

terraform -chdir=environments/production apply  # run from another directory

# ── Inspect ───────────────────────────────────────────────────────────────────
terraform show                          # human-readable current state
terraform show tfplan                   # human-readable saved plan
terraform show -json tfplan | jq .      # machine-readable plan
terraform output                        # print all outputs
terraform output db_endpoint            # print single output value
terraform output -json                  # JSON for scripting
terraform providers                     # list required providers and versions
terraform version                       # terraform + provider versions
terraform graph | dot -Tsvg > graph.svg # dependency graph (requires graphviz)

# ── State ─────────────────────────────────────────────────────────────────────
terraform state list                    # list all resources in state
terraform state list 'module.vpc.*'     # filter by prefix
terraform state show aws_instance.web   # show full state for one resource
terraform state pull                    # download remote state as JSON
terraform state push terraform.tfstate  # overwrite remote state (dangerous!)

terraform state rm aws_instance.web     # remove from state without destroying
terraform state mv aws_instance.old aws_instance.new  # rename/move in state
terraform state mv -dry-run ...         # preview mv without applying

# bulk delete from state (e.g. after importing resource names changed)
terraform state list | grep 'module.old' | xargs -I{} terraform state rm '{}'

# moving list items: e.g. delete index [3] from module.ec2[0..4]
# 1. mv [3] → [5] (temp), mv [4] → [3], update tfvars/count, apply
terraform state mv 'module.ec2[3].aws_instance.this[0]' 'module.ec2[5].aws_instance.this[0]'
terraform state mv 'module.ec2[4].aws_instance.this[0]' 'module.ec2[3].aws_instance.this[0]'

# ── Import existing resources ─────────────────────────────────────────────────
# 1. Write the resource block in .tf first
# 2. Run import to attach it to state
terraform import aws_instance.myvm i-0abc123def456
terraform import 'module.vpc.aws_subnet.private[0]' subnet-0abc123

# Terraform ≥ 1.5: import block in .tf (no CLI needed, reviewed in plan)
# import {
#   to = aws_s3_bucket.legacy
#   id = "my-bucket-name"
# }

# ── Workspaces ────────────────────────────────────────────────────────────────
terraform workspace list                # list workspaces (* = current)
terraform workspace new staging         # create and switch to workspace
terraform workspace select production   # switch workspace
terraform workspace show                # print current workspace name
terraform workspace delete staging      # delete workspace (must not be current)
# use in code: terraform.workspace == "production" ? var.prod_size : var.dev_size

# ── Backend / remote state ────────────────────────────────────────────────────
# S3 backend (backend.tf):
# terraform {
#   backend "s3" {
#     bucket         = "my-tfstate"
#     key            = "prod/terraform.tfstate"
#     region         = "eu-central-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"  # prevents concurrent applies
#   }
# }

# partial backend config (pass secrets at init, not in code):
terraform init -backend-config=backend.hcl
# backend.hcl contains: bucket = "..." / access_key = "..."

# ── Useful patterns ───────────────────────────────────────────────────────────

# auto-approve only in CI; always review plan locally first
TF_LOG=DEBUG terraform apply 2>&1 | tee apply.log   # full debug log

# unlock stuck state (if apply crashed mid-run)
terraform force-unlock LOCK_ID

# generate docs from variables/outputs (requires terraform-docs)
terraform-docs markdown . > README.md

# check which resources will be recreated (not just updated)
terraform plan -out=p && terraform show -json p | jq '[.resource_changes[] | select(.change.actions[] == "delete")] | length'

# ── Ecosystem tools ───────────────────────────────────────────────────────────
# OpenTofu    — OSS fork (MPL-2.0), drop-in TF replacement after BSL change
#               https://opentofu.org  |  brew install opentofu  |  alias tf=tofu
#
# Terragrunt  — DRY wrapper: one backend config for all envs, dependency graph
#               https://terragrunt.gruntwork.io
#
# terraform-docs — auto-generate module documentation from variables/outputs
#               https://terraform-docs.io
#
# tflint      — linter for TF code (catches unused vars, wrong types, AWS rules)
#               https://github.com/terraform-linters/tflint
#
# Infracost   — cost estimation from a plan before applying
#               https://www.infracost.io
#
# Checkov     — static security/compliance scanner for TF code
#               https://www.checkov.io

# ── Learning ──────────────────────────────────────────────────────────────────
# Official tutorials:  https://developer.hashicorp.com/terraform/tutorials
# Best practices:      https://www.terraform-best-practices.com/
# Module registry:     https://registry.terraform.io/
