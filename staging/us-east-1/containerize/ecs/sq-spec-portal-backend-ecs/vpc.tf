data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "sq-spec-portal-backend-vpc-staging"
  cidr = var.vpc_cidr

  azs            = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets = var.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name      = "sq-spec-portal-backend-vpc-staging"
    ManagedBy = "Terraform"
  }
}
