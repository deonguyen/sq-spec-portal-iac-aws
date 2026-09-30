terraform {
  backend "s3" {
    bucket  = "stage-sq-cc-projects-tfstate"
    key     = "stage/us-east-1/containerize/ecs/sq-spec-portal-frontend-ecs/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
