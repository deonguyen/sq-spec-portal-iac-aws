terraform {
  backend "s3" {
    bucket         = "sq-spec-portal-terraform-state-dev"
    key            = "dev/iam/sq-spec-portal-backend-iam-user-group-dev/terraform.tfstate"
    region         = "us-east-2"
    use_lockfile   = true
    encrypt        = true
  }
}