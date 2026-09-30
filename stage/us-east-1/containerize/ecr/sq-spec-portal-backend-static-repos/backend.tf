terraform {
  backend "s3" {
    bucket  = "stage-sq-cc-projects-tfstate"
    key     = "stage/us-east-1/containerize/ecr/sq-spec-portal-backend-static-repos/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
