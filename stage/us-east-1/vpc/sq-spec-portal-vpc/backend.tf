terraform {
  backend "s3" {
    bucket  = "stage-sq-cc-projects-tfstate"
    key     = "stage/us-east-1/vpc/sq-spec-portal-vpc/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
