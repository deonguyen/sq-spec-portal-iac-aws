variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-2"
}

variable "github_org" {
  description = "The GitHub organization."
  type        = string
  default     = "deonguyen" # TODO: Change to your GitHub organization
}

variable "github_repo" {
  description = "The GitHub repository."
  type        = string
  default     = "sq-spec-portal-backend" # TODO: Change to your GitHub repository
}

variable "allowed_secret_arns" {
  description = "A list of secret ARNs that GitHub Actions is allowed to access."
  type        = list(string)
  default     = []
}

variable "allowed_s3_bucket_arns" {
  description = "A list of S3 bucket ARNs that GitHub Actions is allowed to access."
  type        = list(string)
  default     = []
}