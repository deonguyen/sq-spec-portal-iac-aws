terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "dev/s3pypi/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}