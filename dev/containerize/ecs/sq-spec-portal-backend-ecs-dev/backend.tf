terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "dev/containerize/ecs/sq-spec-portal-ecs-dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
