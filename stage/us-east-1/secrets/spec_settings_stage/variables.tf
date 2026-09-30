variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "secret_name" {
  description = "The name of the secret to create."
  type        = string
  default     = "SPEC-SETTINGS-STAGE"
}

variable "spec_settings" {
  description = "A map of specification settings for the stage environment."
  type = object({
    DEBUG                 = string
    ALLOWED_HOSTS         = string
    DJANGO_RUNSERVER_PORT = string
    WOVEY_API_KEY         = string
    WOVEY_API_URL         = string
  })
  default = {
    DEBUG                 = "False"
    ALLOWED_HOSTS         = "*"
    DJANGO_RUNSERVER_PORT = "5013"
    WOVEY_API_KEY         = ""
    WOVEY_API_URL         = ""
  }
  sensitive = true
}
