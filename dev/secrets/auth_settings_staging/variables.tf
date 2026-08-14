variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "secret_name" {
  description = "The name of the secret to create."
  type        = string
  default     = "AUTH-SETTINGS-STAGING"
}

variable "auth_settings" {
  description = "A map of authentication settings for the staging environment."
  type        = map(string)
  default     = {}
  sensitive = true
}