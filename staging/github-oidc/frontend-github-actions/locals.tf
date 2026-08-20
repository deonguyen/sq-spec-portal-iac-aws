terraform {
  required_providers {
    tfc = { source = "hashicorp/tfc" }
  }
}

data "tfc_outputs" "parent" {
  organization = "your-tfc-org" # TODO: update with your terraform cloud organization
  workspace    = "your-parent-workspace-name" # TODO: update with your parent workspace name
}

locals {
  aws_region     = data.tfc_outputs.parent.values.aws_region
  aws_account_id = data.tfc_outputs.parent.values.aws_account_id
  github_org     = data.tfc_outputs.parent.values.github_org
  github_repo    = data.tfc_outputs.parent.values.github_repo
}