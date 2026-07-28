terraform {
  backend "s3" {
    bucket         = "sq-spec-portal-terraform-state-dev"
    key            = "dev/secrets/sq-spec-portal-backend-encryption-key-dev/terraform.tfstate"
    region         = "us-east-2"
    use_lockfile   = true
    encrypt        = true
  }
}