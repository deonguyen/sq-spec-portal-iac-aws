terraform {
  backend "s3" {
    bucket         = "sq-spec-portal-backend-tfstate"
    key            = "dev/iam/sq-spec-portal-backend-iam-user-dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}