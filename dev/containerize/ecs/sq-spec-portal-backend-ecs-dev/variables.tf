variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "service_name" {
  description = "Common prefix for the ECS cluster, log groups, ALB, IAM roles, and service names."
  type        = string
  default     = "sq-spec-portal-ecs"
}

# Each entry defines one backend deployed behind the shared ALB.
# path_patterns are matched by ALB listener rules (in `priority` order).
# container_port is the port the app listens on inside the task; the ALB
# target group forwards traffic directly to this port on the app container.
# Provide `ecr_repository_name` for a private ECR image, or `image` for a
# fully-qualified reference (e.g. a public Docker Hub image like
# "nginx:1.25-alpine"). Exactly one of the two must be set.
variable "services" {
  description = "Backend services to deploy behind the shared ALB."
  type = map(object({
    ecr_repository_name = optional(string)
    image               = optional(string)
    image_tag           = optional(string, "latest")
    command             = optional(list(string))
    container_port      = number
    path_patterns       = list(string)
    priority            = number
    desired_count       = optional(number, 1)
    environment         = optional(map(string), {})
    health_check_path   = optional(string)
  }))
  validation {
    condition = alltrue([
      for k, s in var.services :
      (s.ecr_repository_name != null) != (s.image != null)
    ])
    error_message = "Each service must set exactly one of `ecr_repository_name` or `image`."
  }
  default = {
    admin = {
      ecr_repository_name = "sq-spec-portal-backend-admin-repos"
      container_port      = 5011
      path_patterns       = ["/admin", "/admin/*"]
      health_check_path   = "/admin/health"
      priority            = 10
    }
    # Public nginx image serving Django static files for the admin service.
    # The command override switches nginx from its default port 80 to 5080 so
    # the ALB target group can reach it; provide the static file content via a
    # bind mount, EFS volume, or a custom image built on top of this base.
    static = {
      ecr_repository_name = "sq-spec-portal-backend-static-repos"
      container_port      = 80
      path_patterns       = ["/static", "/static/*"]
      priority            = 30
      health_check_path   = "/"
    }
    auth = {
      ecr_repository_name = "sq-spec-portal-backend-auth-repos"
      container_port      = 5012
      path_patterns       = ["/auth", "/auth/*"]
      priority            = 20
      health_check_path   = "/auth/health" # Add a dedicated health check endpoint
    }
    # spec = {
    #   ecr_repository_name = "sq-spec-portal-backend-spec-repos"
    #   container_port      = 5013
    #   path_patterns       = ["/spec", "/spec/*"]
    #   priority            = 40
    # }
    # snapshot = {
    #   ecr_repository_name = "sq-spec-portal-backend-snapshot-repos"
    #   container_port      = 5014
    #   path_patterns       = ["/snapshot", "/snapshot/*"]
    #   priority            = 50
    # }
  }
}

variable "task_cpu" {
  description = "Fargate task CPU units per service task. 512 = 0.5 vCPU."
  type        = string
  default     = "1024"
}

variable "task_memory" {
  description = "Fargate task memory in MB per service task."
  type        = string
  default     = "2048"
}

variable "app_cpu" {
  description = "CPU units reserved for the Django app container."
  type        = number
  default     = 1024
}

variable "app_memory" {
  description = "Memory (MB) reserved for the Django app container."
  type        = number
  default     = 2048
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

variable "vpc_cidr" {
  description = "CIDR block for the VPC created for the ECS services."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets (ALB + Fargate tasks with public IP)."
  type        = list(string)
  default     = ["10.20.101.0/24", "10.20.102.0/24"]
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention (in days) for container logs."
  type        = number
  default     = 7
}

variable "assign_public_ip" {
  description = "Whether Fargate tasks get a public IP. Required when running in public subnets without a NAT gateway so ECR pulls succeed."
  type        = bool
  default     = true
}

variable "github_actions_role_name" {
  description = "Name of the GitHub Actions OIDC role (from dev/github-oidc) that runs `terraform apply` against this module."
  type        = string
  default     = "sq-spec-portal-backend-github-actions-role"
}

variable "alb_log_bucket_name" {
  description = "Name of the S3 bucket to store ALB access logs."
  type        = string
  default     = "sq-spec-portal-backend-elb-log"
}
