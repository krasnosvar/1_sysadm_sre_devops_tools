variable "main_vars" {
  type    = any
  default = {}
}

# vpc, network vars
variable "network_vars" {
  type    = any
  default = {}
}


# eks 
variable "eks_vars" {
  type    = any
  default = {}
}


#  for alb
variable "aws_alb_controller_ingress_vars" {
  type    = any
  default = {}
}
