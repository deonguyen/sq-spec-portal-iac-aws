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