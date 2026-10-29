variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance."
  type        = string
  default     = "sq-spec-portal-ec2-stage"
}

variable "instance_type" {
  description = "The EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch the instance in. If null, resolved from the VPC state."
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the instance."
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Key pair name for SSH access (optional)."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance."
  type        = bool
  default     = false
}

variable "vpc_state_path" {
  description = "Relative path to the VPC Terraform state file."
  type        = string
  default     = "../../vpc/terraform.tfstate"
}

variable "allowed_ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed to connect via SSH (port 22)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}