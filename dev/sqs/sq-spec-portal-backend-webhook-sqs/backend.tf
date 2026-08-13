terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "dev/sqs/sq-spec-portal-backend-webhook-sqs/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
