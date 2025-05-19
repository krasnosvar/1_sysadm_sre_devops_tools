# https://developer.hashicorp.com/terraform/cli
# Terraform basic commands
#   init          Prepare your working directory for other commands
#   validate      Check whether the configuration is valid
#   plan          Show changes required by the current configuration
#   apply         Create or update infrastructure
#   destroy       Destroy previously-created infrastructure
# initialize 
# https://developer.hashicorp.com/terraform/cli/commands/init
terraform init
# plan 
# sync with only with state-file
terraform plan
# sync with real infra, resfresh state file according to real infra
# https://developer.hashicorp.com/terraform/cli/commands/refresh
# The terraform refresh command reads the current settings from all managed remote objects and updates the Terraform state to match. 
# This command is deprecated. Instead, add the -refresh-only flag to terraform apply and terraform plan commands.
# This does not modify your real remote objects, but it modifies the Terraform state.
terraform apply -refresh-only
# validate configuration
terraform validate
# format to canonical style ( align spaces, "=" , etc.)
terraform fmt
# The terraform show command provides human-readable output from a state or plan file. 
# Use the command to inspect a plan to ensure that the planned operations are expected, or to inspect the current state as Terraform sees it.
terraform show
# The terraform providers command shows information about the provider requirements of the configuration 
# in the current working directory, as an aid to understanding where each requirement was detected from.
# https://developer.hashicorp.com/terraform/cli/commands/providers
terraform providers


# change current working dir to another
terraform -chdir=environments/production apply


# STATE
# terraform state commands
# download remote state file
terraform state pull
# list all resources from state-file ( state is ok, if local, or configured, if S3)
terraform state list
# remove resource form state-file ( for example if resource deleted via AWS UI and still exists in state)
state rm aws_db_parameter_group.aurora_db_pgs13_param_group
# add resource to state-file
import aws_db_parameter_group.aurora_db_pgs13_param_group dev-db-pgs13-param-group

# if using terraform with modules, for example- created multiple ec2 instamces, and need to delete resource form the middle of the list
# need to use 'terraform state mv' and 'terraform state rm' commands
# we have in state list of 5 instances [0 1 2 3 4], need to delete [3]
#1. move instance [3] to [5] index, and all related resources, such as ESB devices ( temporarilly)
# with dry-run to check
terraform state mv -dry-run 'module.ec2[3].aws_instance.this[0]' 'module.ec2[5].aws_instance.this[0]'
terraform state mv 'aws_volume_attachment.ebs_attach[3]' 'aws_volume_attachment.ebs_attach[5]'
#2. then move [4] to [3]
# 3. rewrite terraform.tfvars vars and execute 'terraform plan' to check all is ok, then can be applied 'terraform apply'

# import exisiting resource to terraform state
# https://spacelift.io/blog/importing-exisiting-infrastructure-into-terraform
# 1. Write config for the already created ( for example manually or by another tool ) resource to be imported in main.tf
# 2. Run the import command 
terraform import aws_instance.myvm <Instance ID>
