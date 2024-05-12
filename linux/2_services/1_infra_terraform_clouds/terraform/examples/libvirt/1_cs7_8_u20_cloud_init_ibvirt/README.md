# Terraform for local stands in Ubuntu


1. Creates multiple VMs for tst-stands by editing ```variable "hostname"``` ( add to list)
```
# variables that can be overriden
variable "hostname" {
  type    = list(string)
  # default = ["dev1-centos8", "dev2-centos8"]
  default = ["dev1-u2004_111"]
}
```
2. Commands
```
terraform apply -auto-approve
terraform destroy -auto-approve
terraform refresh
```