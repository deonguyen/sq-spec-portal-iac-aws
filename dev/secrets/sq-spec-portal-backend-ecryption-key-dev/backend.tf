terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "dev/secrets/sq-spec-portal-backend-ecryption-key-dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}