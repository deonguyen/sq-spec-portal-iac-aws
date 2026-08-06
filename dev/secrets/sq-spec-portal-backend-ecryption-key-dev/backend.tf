terraform {
  backend "s3" {
    bucket         = "sq-spec-portal-backend-tfstate"
    key            = "dev/secrets/sq-spec-portal-backend-encryption-key-dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}