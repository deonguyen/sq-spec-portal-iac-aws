data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "sq-spec-portal-tfstate"
    # This key points to the state file for your staging VPC
    key    = "staging/us-east-1/vpc/sq-spec-portal-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}