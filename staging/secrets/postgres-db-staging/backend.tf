terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "staging/secrets/postgres-db-staging/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}