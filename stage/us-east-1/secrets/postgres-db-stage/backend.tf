terraform {
  backend "s3" {
    bucket  = "stage-sq-cc-projects-tfstate"
    key     = "stage/us-east-1/secrets/postgres-db-stage/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
