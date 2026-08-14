variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "secret_name" {
  description = "The name of the secret to create."
  type        = string
  default     = "POSTGRES-DB-STAGING"
}

variable "db_settings" {
  description = "A map of database connection settings for the staging environment."
  type        = map(string)
  default = {
    "host"                 = "your-rds-host.rds.amazonaws.com"
    "port"                 = "5432"
    "dbname"               = "your_db_name"
    "username_secret_name" = "sq-spec-portal-db-user"
    "password_secret_name" = "sq-spec-portal-db-password"
  }
  sensitive = true
}