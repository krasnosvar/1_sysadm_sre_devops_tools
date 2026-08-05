# vars

main_vars = {
  profile = ""

  required_tags = {
    Project   = ""
    Platform  = "eks"
    Env       = "dev"
    Stage     = "dev"
    ManagedBy = "terraform"
  }

  aws_region = "us-west-2"
  azs = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c"
  ]
}


# VPC, network vars
# vpc settings
network_vars = {
  vpc = {
    cidr = "10.10.80.0/22"
    # https://jodies.de/ipcalc
    public_subnets = [
      "10.10.83.128/27", # min 10.10.83.129 max: 10.10.83.159 ( broadcast)
      "10.10.83.160/27", # min 161 max: 191 ( broadcast)
      "10.10.83.192/27"  # min 193 max: 223 ( broadcast)
      # "10.10.83.224/27" # min 225 max: 255 ( broadcast)
    ]
    # Due to complexity of if else elif in terraform - we use 3 subnets in 3 avz as standard
    private_subnets = [
      "10.10.80.0/23", # 512 addrs, 10.10.80.0/23 - HostMax: 10.10.81.254
      "10.10.82.0/24", # 256 addresses
      "10.10.83.0/25"  # 128 addresses
    ]
    enable_ipv6 = false
    # True for nat gateway
    enable_nat_gateway = true
    # True for only one nat gw for all AVZ
    single_nat_gateway = true
    reuse_nat_ips      = false
    # True one GW for each AVZ ( incompatible with single_nat_gateway)
    one_nat_gateway_per_az           = false
    enable_dns_hostnames             = true
    enable_dns_support               = true
    enable_dhcp_options              = true
    map_public_ip_on_launch          = false
    dhcp_options_domain_name_servers = ["169.254.169.253", "1.1.1.1", "8.8.8.8"]
  },
  # Transit Gateway ID
  # This is created by Admin stuff in the region the platform will be in before hand
  # if you don't have it - request a site2site to be made - or share with account if it's a client one
  site2site_vpn_transit_gw_id = "tgw-0...6",
  site2site_vpn_routes = [],
  site2site_vpn_routes_exclude = [],

  # security setting for ingress, for outgoing rules you will need to extend the config to require them
  # for more info refer to security module and it's documentation
  security_groups = {
    ingress_cidr_blocks = []
    ingress_with_cidr_blocks = [
      # ICMP questionable, but use full
      {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        description = "User-service ports (ipv4)"
        cidr_blocks = "0.0.0.0/0"
      },
      #SSH access , questionable, but to be double sure we have fail2ban installation as a default in our playbooks
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        description = "User-service ports (ipv4)"
        cidr_blocks = "0.0.0.0/0"
      },
      # VPC network
      {
        from_port   = 0
        to_port     = 65535
        protocol    = "TCP"
        description = "VPC network"
        cidr_blocks = "10.10.80.0/22"
      },
      {
        from_port   = 0
        to_port     = 65535
        protocol    = "UDP"
        description = "VPC network"
        cidr_blocks = "10.10.80.0/22"
      },
      ####### CLIENT BLOCK
      {
        from_port   = 80
        to_port     = 80
        protocol    = "TCP"
        description = "HTTP"
        cidr_blocks = "0.0.0.0/0"
      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "TCP"
        description = "HTTPS"
        cidr_blocks = "0.0.0.0/0"
      },
    ]
    ingress_rules = []
    egress_rules = [
      "all-all"
    ]
  }

}


# cluster vars
# EKS nodes, node_groups vars
eks_vars = {
  # cluster
  cluster_version = 1.33
  # node group vars
  # node_instance_type = "m6i.large" # 2cpu 8ram
  node_instance_type = "m6i.large"
  desired_capacity   = 2
  min_size           = 2
  max_size           = 3
  ami_type           = "AL2023_x86_64_STANDARD"
  disk_size          = 50
  ec2_ssh_key        = "my-eks-key"
  #addons
  eks_addons = [{
    name    = "kube-proxy"
    version = "v1.33.0-eksbuild.2"
    },
    {
      name    = "vpc-cni"
      version = "v1.19.5-eksbuild.3"
    },
    {
      name    = "coredns"
      version = "v1.12.1-eksbuild.2"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.44.0-eksbuild.1"
    },
    # https://docs.aws.amazon.com/eks/latest/userguide/community-addons.html#_available_community_add_ons
    # aws --region us-west-2 eks describe-addon-versions --addon-name metrics-server --kubernetes-version 1.33
    { name = "metrics-server"
    version = "v0.7.2-eksbuild.3" }
  ]
}

aws_alb_controller_ingress_vars = {
  # core helms versions
  alb_helm_ver     = "1.13.2"
  ingress_helm_ver = "4.12.2"
}
