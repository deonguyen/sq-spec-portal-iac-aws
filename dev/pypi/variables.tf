variable "project_name" {
  description = "Name of the project to use for resource prefixes."
  type        = string
  default     = "pypi-server-dev"
}

variable "aws_region" {
  description = "The AWS region for the resources."
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet."
  type        = string
  default     = "10.1.1.0/24"
}

variable "instance_type" {
  description = "The EC2 instance type for the PyPI server."
  type        = string
  default     = "t3.micro"
}

variable "pypi_bucket_name" {
  description = "The name of the S3 bucket to store PyPI packages."
  type        = string
  default     = "sq-spec-portal-pypi-packages-dev"
}

variable "pypi_admin_user" {
  description = "The username for the PyPI server admin."
  type        = string
  default     = "admin"
}

variable "pypi_admin_password" {
  description = "The password for the PyPI server admin."
  type        = string
  default     = "admin"
  sensitive   = true
}