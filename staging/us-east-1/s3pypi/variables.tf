variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket for the PyPI server. Must be globally unique."
  type        = string
  default     = "sq-spec-portal-backend-pypi-packages-staging"
}

variable "iam_user_name" {
  description = "The name for the IAM user that will upload packages."
  type        = string
  default     = "s3pypi-uploader-staging"
}

variable "create_bucket" {
  description = "Whether to create the S3 bucket or use an existing one."
  type        = bool
  default     = false
}