terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "staging/us-east-1/iam/sq-spec-portal-backend-iam-user-staging/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}