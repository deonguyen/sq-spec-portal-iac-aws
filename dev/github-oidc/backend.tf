terraform {
  backend "s3" {
    bucket         = "sq-spec-portal-terraform-state-dev"
    key            = "dev/github-oidc/terraform.tfstate"
    region         = "us-east-2"
    use_lockfile   = true
    encrypt        = true
  }
}