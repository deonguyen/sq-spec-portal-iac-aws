###### provider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  allowed_account_ids = ["885388406688"]
  profile = "woven-sso"

  default_tags {
    tags = {
      "woven:app"        = "agora-sq-cc-projects-aws-3QuQ1G1"
      "woven:deployment" = "tf"
      "woven:env"        = "dev"
      "woven:org-code"   = "AC810"
    }
  }

  # Following tags are auto-generated
  ignore_tags {
    keys = [
      "woven:created:at",
      "woven:created:by"
    ]
  }
}

provider "aws" {
  alias   = "replica"
  region  = "us-west-2"
  allowed_account_ids = ["885388406688"]
  profile = "woven-sso"
}
