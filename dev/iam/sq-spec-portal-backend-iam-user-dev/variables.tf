variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "iam_user_name" {
  description = "The name for the IAM user."
  type        = string
  default     = "sq-spec-portal-backend-iam-user-dev"
}