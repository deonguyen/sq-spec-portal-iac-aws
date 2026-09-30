variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "The name of the database VPC."
  type        = string
  default     = "sq-spec-portal-db-vpc-stage"
}

variable "vpc_cidr" {
  description = "The CIDR block for the database VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnets_cidr" {
  description = "List of CIDR blocks for public subnets (at least 2 required for RDS)."
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones to use for the subnets."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}