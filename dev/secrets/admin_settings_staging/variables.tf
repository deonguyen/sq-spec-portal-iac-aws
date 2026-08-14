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
  type = object({
    DEBUG                 = string
    ALLOWED_HOSTS         = string
    DJANGO_RUNSERVER_PORT = string
  })
  default = {
    DEBUG                 = "False"
    ALLOWED_HOSTS         = "*"
    DJANGO_RUNSERVER_PORT = "5011"
  }
  sensitive = true
}
