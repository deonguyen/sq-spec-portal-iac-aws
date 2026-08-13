terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "dev/containerize/sq-spec-portal-backend-static-server-repos/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
