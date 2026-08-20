###### provider.tf
terraform {
  required_providers {
    tfc = { source = "hashicorp/tfc" }
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
