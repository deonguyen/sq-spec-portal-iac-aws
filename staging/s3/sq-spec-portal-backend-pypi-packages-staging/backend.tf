terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "staging/s3/sq-spec-portal-backend-pypi-packages/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}