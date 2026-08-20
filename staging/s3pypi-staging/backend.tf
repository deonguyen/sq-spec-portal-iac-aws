terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "staging/s3pypi/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}