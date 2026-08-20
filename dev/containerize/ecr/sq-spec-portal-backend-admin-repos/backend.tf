terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "dev/containerize/ecr/sq-spec-portal-backend-admin-repos/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
