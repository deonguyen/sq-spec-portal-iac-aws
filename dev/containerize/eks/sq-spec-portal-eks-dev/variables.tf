variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "sq-spec-portal-eks"
}

variable "github_oidc_provider_arn" {
  description = "The ARN of the GitHub OIDC provider in AWS IAM."
  type        = string
  default     = "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
}

variable "github_org" {
  description = "The GitHub organization."
  type        = string
  default     = "deonguyen"
}

variable "github_repo" {
  description = "The GitHub repository."
  type        = string
  default     = "sq-spec-portal-backend"
}

variable "aws_region" {
  description = "The AWS region for the EKS cluster."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "instance_types" {
  description = "The instance types for the EKS node group."
  type        = list(string)
  default     = ["t3.micro"]
}

variable "desired_size" {
  description = "The desired number of worker nodes."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of worker nodes."
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The minimum number of worker nodes."
  type        = number
  default     = 1
}