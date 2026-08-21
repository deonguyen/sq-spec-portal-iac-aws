terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "staging/us-east-1/secrets/aws-secrets-to-settings-staging/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}