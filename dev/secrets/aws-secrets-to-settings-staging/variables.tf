variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "secret_name" {
  description = "The name of the secret to create."
  type        = string
  default     = "AWS-SECRETS-TO-SETTINGS-STAGING"
}

variable "db_info" {
  description = "Database connection information"
  type = object({
    DB_INFO = string
    ADMIN_SETTINGS = string
    AUTH_SETTINGS = string
    SPEC_SETTINGS = string
    SNAPSHOT_SETTINGS = string
  })
  default = {
    DB_INFO = "POSTGRES-DB-STAGING"
    ADMIN_SETTINGS = "ADMIN-SETTINGS-STAGING"
    AUTH_SETTINGS = "AUTH-SETTINGS-STAGING"
    SPEC_SETTINGS = "SPEC-SETTINGS-STAGING"
    SNAPSHOT_SETTINGS = "SNAPSHOT-SETTINGS-STAGING"
  }
  sensitive = true
}