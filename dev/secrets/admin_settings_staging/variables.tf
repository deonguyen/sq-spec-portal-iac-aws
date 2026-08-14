variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "secret_name" {
  description = "The name of the secret to create."
  type        = string
  default     = "ADMIN-SETTINGS-STAGING"
}

variable "admin_settings" {
  description = "A map of admin settings to be stored in the secret."
  type        = map(string)
  default     = {}
  sensitive = true
}