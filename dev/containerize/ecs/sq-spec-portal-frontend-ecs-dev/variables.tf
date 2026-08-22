variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "ecr_repository_name" {
  description = "The name of the ECR repository holding the Next.js application image."
  type        = string
  default     = "sq-spec-portal-frontend-repos-staging"
}

variable "image_tag" {
  description = "The image tag to deploy from the ECR repository."
  type        = string
  default     = "staging" # TODO: update with the desired image tag
}

variable "container_port" {
  description = "The port the Next.js container listens on."
  type        = number
  default     = 3002
}

variable "cpu" {
  description = "Fargate task CPU units. 256 is the smallest supported value (0.25 vCPU)."
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Fargate task memory in MB. 512 is the smallest value compatible with 256 CPU."
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Desired number of ECS tasks running the Next.js app."
  type        = number
  default     = 1
}

variable "enable_container_insights" {
  description = "Enable ECS Container Insights. Adds CloudWatch metrics cost; keep off for smallest footprint."
  type        = bool
  default     = false
}

variable "use_fargate_spot" {
  description = "Use FARGATE_SPOT capacity provider instead of on-demand FARGATE. ~70% cheaper; tasks can be interrupted with 2 minute notice."
  type        = bool
  default     = true
}

variable "runtime_environment_variables" {
  description = "Environment variables passed to the Next.js container at runtime."
  type        = map(string)
  default     = {}
}

variable "health_check_path" {
  description = "HTTP path used by the ALB target group health check."
  type        = string
  default     = "/"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC created for the ECS service."
  type        = string
  default     = "10.30.0.0/16"
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets (ALB + Fargate tasks with public IP)."
  type        = list(string)
  default     = ["10.30.101.0/24", "10.30.102.0/24"]
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention (in days) for the Next.js task logs. Small value keeps storage cost near zero."
  type        = number
  default     = 7
}

variable "assign_public_ip" {
  description = "Whether Fargate tasks get a public IP. Required when running in public subnets without a NAT gateway so ECR pulls succeed."
  type        = bool
  default     = true
}

variable "github_actions_role_name" {
  description = "Name of the GitHub Actions OIDC role (from dev/github-oidc) that runs `terraform apply` against this module. Kept as a name (not ARN) so we can attach a policy in-place without needing a data source."
  type        = string
  default     = "sq-spec-portal-frontend-github-actions-role" # Assumes a new role for the frontend
}