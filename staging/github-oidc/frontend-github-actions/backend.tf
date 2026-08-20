terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "staging/github-oidc/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}