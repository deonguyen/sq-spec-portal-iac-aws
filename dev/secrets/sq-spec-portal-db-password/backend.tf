terraform {
  backend "s3" {
    bucket         = "sq-spec-portal-backend-tfstate"
    key            = "dev/secrets/sq-spec-portal-db-password/terraform.tfstate"
    region         = "us-east-2"
    use_lockfile   = true
    encrypt        = true
  }
}