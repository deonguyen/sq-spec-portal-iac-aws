variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "secret_name" {
  description = "The name of the secret to create."
  type        = string
  default     = "SPEC-SETTINGS-STAGING"
}

variable "spec_settings" {
  description = "A map of specification settings for the staging environment."
  type = object({
    DEBUG = string
    ALLOWED_HOSTS = string
    DJANGO_RUNSERVER_PORT = string
  })
  default = {
    DEBUG = "False"
    ALLOWED_HOSTS = "*"
    DJANGO_RUNSERVER_PORT = "5013"
  }
  sensitive = true
}