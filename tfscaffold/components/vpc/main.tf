module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name                 = "${var.project}_${var.environment}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr                 = var.cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
  public_subnets  = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]

  enable_nat_gateway      = false
  single_nat_gateway      = false
  enable_vpn_gateway      = false
  one_nat_gateway_per_az  = false
  map_public_ip_on_launch = true

  # Adding tags to public subnets
  public_subnet_tags = {
    "Name"                                            = "Public_Subnet_${local.eks_cluster_name}"
    "Type"                                            = "Public_Subnets"
    "kubernetes.io/role/elb"                          = 1
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "ManagedBy"                                       = "Terraform"

  }

  # Adding tags to private subnets
  private_subnet_tags = {
    "Name"                                            = "Private_Subnet_${local.eks_cluster_name}"
    "Type"                                            = "Private Subnets"
    "kubernetes.io/role/internal-elb"                 = 1
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "ManagedBy"                                       = "Terraform"
  }

  public_route_table_tags = {
    "Name"      = "public-route-table-${local.eks_cluster_name}"
    "Type"      = "public_route_table_tags"
    "ManagedBy" = "Terraform"
  }

  private_route_table_tags = {
    "Name"      = "private-route-table-${local.eks_cluster_name}"
    "Type"      = "private_route_table_tags"
    "ManagedBy" = "Terraform"
  }

  tags = merge(
    local.tags,
    {
      "Name" = "${local.eks_cluster_name}"
      "Role" = var.component
    },
  )
}