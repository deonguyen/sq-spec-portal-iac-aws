terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "staging/us-east-1/vpc/sq-spec-portal-vpc/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}