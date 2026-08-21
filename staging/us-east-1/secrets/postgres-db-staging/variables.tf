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
  type = object({
    DB_USER     = string
    DB_PASSWORD = string
    DB_NAME     = string
    DB_HOST     = string
    DB_PORT     = number
  })
  default = {
    DB_USER     = "sqspecportaldbuser"
    DB_PASSWORD = "?DjTdtUNS(Kk0P{="
    DB_NAME     = "sqspecportaldbstaging"
    DB_HOST     = "sq-spec-portal-db-staging.cyjka22ku5q8.us-east-1.rds.amazonaws.com"
    DB_PORT     = 5432
  }
  sensitive = true
}
