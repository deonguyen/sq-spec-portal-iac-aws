variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "service_name" {
  description = "The name of the ECS service (also used as the cluster and log group prefix)."
  type        = string
  default     = "snapshot-ecs"
}

variable "ecr_repository_name" {
  description = "The name of the ECR repository holding the Django application image."
  type        = string
  default     = "sq-spec-portal-backend-snapshot-repos"
}

variable "image_tag" {
  description = "The image tag to deploy from the ECR repository."
  type        = string
  default     = "latest"
}

variable "container_port" {
  description = "The port the Django container listens on."
  type        = number
  default     = 5014
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
  description = "Desired number of ECS tasks running the Django app."
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
  description = "Environment variables passed to the Django container at runtime."
  type        = map(string)
  default     = {}
}

variable "health_check_path" {
  description = "HTTP path used by the ALB target group health check."
  type        = string
  default     = "/health"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC created for the ECS service."
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets (ALB + Fargate tasks with public IP)."
  type        = list(string)
  default     = ["10.10.101.0/24", "10.10.102.0/24"]
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention (in days) for the Django task logs. Small value keeps storage cost near zero."
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
  default     = "sq-spec-portal-backend-github-actions-role"
}
