variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
  default     = "sqspecportaldbstaging"
}

variable "db_username" {
  description = "The username for the master database user."
  type        = string
  default     = "sqspecportaldbuser"
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
  default     = "db.t3.micro"
}