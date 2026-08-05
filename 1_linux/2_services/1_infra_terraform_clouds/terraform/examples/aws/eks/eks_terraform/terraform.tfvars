# vars
main_vars = {}

# VPC, network vars
# vpc settings
network_vars = {
  vpc                         = {}
  site2site_vpn_transit_gw_id = ""
  site2site_vpn_routes        = []
  security_groups             = {}
}

# cluster vars
# EKS nodes, node_groups vars
eks_vars                        = {}
aws_alb_controller_ingress_vars = {}
