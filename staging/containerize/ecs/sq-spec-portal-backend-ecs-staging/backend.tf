terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "staging/containerize/ecs/sq-spec-portal-ecs-staging/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
