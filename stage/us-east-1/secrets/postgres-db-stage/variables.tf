variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "secret_name" {
  description = "The name of the secret to create."
  type        = string
  default     = "POSTGRES-DB-STAGE"
}

variable "db_settings" {
  description = "A map of database connection settings for the stage environment."
  type = object({
    DB_USER     = string
    DB_PASSWORD = string
    DB_NAME     = string
    DB_HOST     = string
    DB_PORT     = number
  })
  default = {
    DB_USER     = "sqspecportaldbuser"
    DB_PASSWORD = "E#gez[M1Fh&#XA+{"
    DB_NAME     = "sqspecportaldbstage"
    DB_HOST     = "sq-spec-portal-db-stage.c6ji80k6i2dh.us-east-1.rds.amazonaws.com"
    DB_PORT     = 5432
  }
  sensitive = true
}
