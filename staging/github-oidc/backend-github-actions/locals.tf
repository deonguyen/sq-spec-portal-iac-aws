data "tfc_outputs" "parent" {
  github_org = "deonguyen" # TODO: update with your terraform cloud organization
  github_repo    = "sq-spec-portal-backend" # TODO: update with your parent workspace name
}

locals {
  aws_region     = data.tfc_outputs.parent.values.aws_region
  aws_account_id = data.tfc_outputs.parent.values.aws_account_id
  backend_bucket = data.tfc_outputs.parent.values.backend_bucket
  github_org     = data.tfc_outputs.parent.values.github_org
  github_repo    = data.tfc_outputs.parent.values.github_repo
}