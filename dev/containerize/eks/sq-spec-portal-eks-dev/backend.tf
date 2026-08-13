terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "dev/containerize/eks/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}