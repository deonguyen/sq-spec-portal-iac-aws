terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "stage-sq-cc-projects-tfstate"
    key     = "stage/us-east-1/vpc/sq-spec-portal-db-vpc/terraform.tfstate"
    region  = "us-east-1"
    profile = "woven-sso"
  }
}

provider "aws" {
  region              = var.aws_region
  profile             = "woven-sso"
  allowed_account_ids = ["673515369016"]
}