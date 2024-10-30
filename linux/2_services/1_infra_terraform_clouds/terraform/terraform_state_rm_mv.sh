# list all resources in state
terraform state list


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
