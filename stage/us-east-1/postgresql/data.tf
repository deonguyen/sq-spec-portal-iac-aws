data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    allowed_account_ids = ["673515369016"]
    profile = "woven-sso"

    bucket = "stage-sq-cc-projects-tfstate"    
    # This key points to the state file for your stage DB VPC
    key    = "stage/us-east-1/vpc/sq-spec-portal-db-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}