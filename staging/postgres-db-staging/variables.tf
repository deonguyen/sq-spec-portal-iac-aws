variable "db_name" {
  description = "The name of the database to create."
  type        = string
  default     = "sqspecportaldbstaging"
}

variable "db_username" {
  description = "The username for the master database user."
  type        = string
  default     = "sqspecportaldbuserstaging"
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to connect to the database."
  type        = list(string)
  default     = ["0.0.0.0/0"] # WARNING: Open to the world. Restrict for production.
}