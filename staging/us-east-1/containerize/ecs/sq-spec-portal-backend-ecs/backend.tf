terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "staging/us-east-1/containerize/ecs/sq-spec-portal-backend-ecs/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
