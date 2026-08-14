terraform {
  backend "s3" {
    bucket  = "sq-spec-portal-tfstate"
    key     = "dev/secrets/snapshot_settings_staging/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}