terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "dev/secrets/aws-secrets-to-settings-staging/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}