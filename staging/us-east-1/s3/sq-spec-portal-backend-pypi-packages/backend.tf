terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "staging/us-east-1/s3/sq-spec-portal-backend-pypi-packages/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}