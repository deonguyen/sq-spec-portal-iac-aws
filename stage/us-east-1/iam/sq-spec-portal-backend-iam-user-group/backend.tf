terraform {
  backend "s3" {
    bucket  = "stage-sq-cc-projects-tfstate"
    key     = "stage/us-east-1/iam/sq-spec-portal-backend-iam-user-group/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
