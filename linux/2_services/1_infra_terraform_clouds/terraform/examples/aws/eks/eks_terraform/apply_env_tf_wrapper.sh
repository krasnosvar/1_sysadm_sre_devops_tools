# bash
# #!/bin/bash
env="$1"
terraform init -backend-config="files/backends_and_tfvars/$env.backend"
terraform apply -var-file="files/backends_and_tfvars/$env.tfvars"
