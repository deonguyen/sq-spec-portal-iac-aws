remote_state {
  backend = "s3"
  config = {
    # This S3 bucket will store all your Terraform state files.
    # It needs to be created once before the first Terragrunt run.
    bucket         = "sq-spec-portal-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1" # Ensure this matches your AWS region
    encrypt        = true
    # This DynamoDB table is used for state locking to prevent concurrent modifications.
    # It also needs to be created once.
    use_lockfile = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}