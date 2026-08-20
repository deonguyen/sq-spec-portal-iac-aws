terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "dev/containerize/ecr/sq-spec-portal-frontend-repos/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
