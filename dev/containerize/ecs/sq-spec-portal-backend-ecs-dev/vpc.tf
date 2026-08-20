data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "${var.service_name}-vpc"
  cidr = var.vpc_cidr

  azs            = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets = var.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name      = "${var.service_name}-vpc"
    ManagedBy = "Terraform"
  }
}
