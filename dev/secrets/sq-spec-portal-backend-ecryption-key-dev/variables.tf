variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-2"
}

variable "secret_name" {
  description = "The name for the AWS Secrets Manager secret."
  type        = string
  default     = "sq-spec-portal-backend-ecryption-key-dev"
}
