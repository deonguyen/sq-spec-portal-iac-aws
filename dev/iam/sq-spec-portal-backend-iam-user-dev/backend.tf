terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "dev/iam/sq-spec-portal-backend-iam-user-dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}