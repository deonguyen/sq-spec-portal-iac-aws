variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "secret_name" {
  description = "The name of the secret to create."
  type        = string
  default     = "AWS-SECRETS-TO-SETTINGS-STAGE"
}

variable "settings" {
  description = "A collection of application settings for the stage environment."
  type = object({
    DB_INFO = string
    ADMIN_SETTINGS = string
    AUTH_SETTINGS = string
    SPEC_SETTINGS = string
    SNAPSHOT_SETTINGS = string
  })
  default = {
    DB_INFO = "POSTGRES-DB-STAGE"
    ADMIN_SETTINGS = "ADMIN-SETTINGS-STAGE"
    AUTH_SETTINGS = "AUTH-SETTINGS-STAGE"
    SPEC_SETTINGS = "SPEC-SETTINGS-STAGE"
    SNAPSHOT_SETTINGS = "SNAPSHOT-SETTINGS-STAGE"
  }
  sensitive = true
}