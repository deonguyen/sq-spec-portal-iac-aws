terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "staging/us-east-1/containerize/ecr/sq-spec-portal-backend-auth-repos/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
