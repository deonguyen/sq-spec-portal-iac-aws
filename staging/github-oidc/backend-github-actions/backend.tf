terraform {
  backend "s3" {
    bucket  = local.backend_bucket
    key     = "staging/github-oidc/backend-github-actions/terraform.tfstate"
    region  = local.aws_region
    encrypt = true
  }
}