###### provider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.3"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  allowed_account_ids = ["673515369016"]
  profile = "woven-sso"

  default_tags {
    tags = {
      "woven:app"               = "sqna-specification-centralized-portal"
      "woven:deployment"        = "tf"
      "woven:env"               = "stage"
      "woven:author"            = "deo.nguyen@woven-planet.global"
      "woven:woven-lob"         = "221"
      "woven:woven-cost-center" = "21403"
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
  allowed_account_ids = ["673515369016"]
  profile = "woven-sso"
}
