module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"
  # insert the 49 required variables here
  name = local.vpc_name

  cidr            = var.network_vars.vpc.cidr
  azs             = var.main_vars.azs
  private_subnets = var.network_vars.vpc.private_subnets
  public_subnets  = var.network_vars.vpc.public_subnets
  # database_subnets       = var.network_vars.vpc.database_subnets
  enable_ipv6            = var.network_vars.vpc.enable_ipv6
  enable_nat_gateway     = var.network_vars.vpc.enable_nat_gateway
  single_nat_gateway     = var.network_vars.vpc.single_nat_gateway
  reuse_nat_ips          = var.network_vars.vpc.reuse_nat_ips
  one_nat_gateway_per_az = var.network_vars.vpc.one_nat_gateway_per_az
  //  external_nat_ip_ids = "${aws_eip.nat.*.id}"
  enable_dns_hostnames    = var.network_vars.vpc.enable_dns_hostnames
  enable_dns_support      = var.network_vars.vpc.enable_dns_support
  map_public_ip_on_launch = var.network_vars.vpc.map_public_ip_on_launch

  # Default security group - ingress/egress rules cleared to deny all
  default_security_group_ingress = []
  default_security_group_egress  = []
  default_security_group_name    = local.vpc_name
  # Default rouble table
  default_route_table_name             = local.vpc_name
  default_route_table_routes           = []
  default_route_table_propagating_vgws = []
  default_route_table_tags             = var.main_vars.required_tags
  # Default network ACL
  default_network_acl_name = local.vpc_name
  tags                     = var.main_vars.required_tags
}

module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.0"
  # insert the 2 required variables here
  name                     = var.main_vars.required_tags.Platform
  vpc_id                   = module.vpc.vpc_id
  ingress_with_cidr_blocks = var.network_vars.security_groups.ingress_with_cidr_blocks
  ingress_cidr_blocks      = var.network_vars.security_groups.ingress_cidr_blocks
  ingress_rules            = var.network_vars.security_groups.ingress_rules
  egress_rules             = var.network_vars.security_groups.egress_rules
  tags                     = var.main_vars.required_tags
}


##############
## tgw
##############
resource "aws_ec2_transit_gateway_vpc_attachment" "site2site" {
  tags               = var.main_vars.required_tags
  subnet_ids         = concat(module.vpc.private_subnets)
  transit_gateway_id = var.network_vars.site2site_vpn_transit_gw_id
  vpc_id             = module.vpc.vpc_id
}

locals {
  routeId_to_site2siteRoutes = flatten([
    for id in flatten(module.vpc.private_route_table_ids) : [
      for route in var.network_vars.site2site_vpn_routes : {
        route_table_id = id
        route          = route
      }
    ]
  ])
}

locals {
  routeId_to_site2siteRoutes_excludes = flatten([
    for id in flatten(module.vpc.private_route_table_ids) : [
      for route in var.network_vars.site2site_vpn_routes_exclude : {
        route_table_id = id
        route          = route
      }
    ]
  ])
}

resource "aws_route" "private_site2site_avz" {
  count          = length(local.routeId_to_site2siteRoutes)
  route_table_id = module.vpc.private_route_table_ids[0]
  //noinspection HILUnresolvedReference
  destination_cidr_block = local.routeId_to_site2siteRoutes[count.index].route
  transit_gateway_id     = var.network_vars.site2site_vpn_transit_gw_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.site2site]
}
