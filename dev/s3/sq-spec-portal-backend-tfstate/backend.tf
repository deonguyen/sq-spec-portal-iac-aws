terraform {
  backend "s3" {
    bucket       = "sq-spec-portal-backend-tfstate"
    key          = "dev/s3/sq-spec-portal-backend-tfstate/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
  }
}