variable "db_name" {
  description = "The name of the database to create."
  type        = string
  default     = "sqspecportaldbdev"
}

variable "db_username" {
  description = "The username for the master database user."
  type        = string
  default     = "sqspecportaldbuserdev"
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
  default     = "db.t3.micro"
}