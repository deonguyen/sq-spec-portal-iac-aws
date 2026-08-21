variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
  default     = "backend-cluster-staging"
}

variable "service_name" {
  description = "Common prefix for the ECS cluster, log groups, ALB, IAM roles, and service names."
  type        = string
  default     = "sq-spec-portal-backend-ecs-staging"
}

# Each entry defines one backend deployed behind the shared ALB.
# path_patterns are matched by ALB listener rules (in `priority` order).
# container_port is the port the app listens on inside the task; the ALB
# target group forwards traffic directly to this port on the app container.
# Provide `ecr_repository_name` for a private ECR image, or `image` for a
# fully-qualified reference (e.g. a public Docker Hub image like
# "nginx:1.25-alpine"). Exactly one of the two must be set.
variable "services" {
  description = "Backend services to deploy behind the shared ALB. Each service can have multiple containers."
  type = map(object({
    service_name        = string
    path_patterns       = list(string)
    priority            = number
    desired_count       = optional(number, 1)
    health_check_path   = optional(string)
    ecr_repository_name = optional(string)
    image               = optional(string)
    image_tag           = optional(string, "latest")
    command             = optional(list(string))
    container_port      = number
    environment         = optional(map(string), {})
    essential           = optional(bool, true)
    cpu                 = optional(number)
    memory              = optional(number)
  }))
  validation {
    condition     = alltrue([for k, s in var.services : (s.ecr_repository_name != null) != (s.image != null)])
    error_message = "Each container must set exactly one of `ecr_repository_name` or `image`."
  }
  default = {
    admin = {
      service_name      = "admin"
      path_patterns     = ["/admin", "/admin/*"]
      health_check_path = "/admin/health"
      priority          = 10
      ecr_repository_name = "sq-spec-portal-backend-admin-repos-staging"
      container_port      = 5011 # Main application container
      cpu                 = 256 # Main application needs more resources
      memory              = 512
    },
    static = {
      service_name        = "admin" # Part of the 'admin' task
      path_patterns       = ["/static/*"]
      health_check_path   = "/"
      priority            = 11
      ecr_repository_name = "sq-spec-portal-backend-static-repos-staging"
      container_port      = 5080
      cpu                 = 256 # Static content server needs less CPU
      memory              = 512 # and memory
    },
    auth = {
      service_name      = "auth"
      path_patterns     = ["/auth", "/auth/*"]
      health_check_path = "/auth/health"
      priority          = 20
      ecr_repository_name = "sq-spec-portal-backend-auth-repos-staging"
      container_port      = 5012
      cpu                 = 512
      memory              = 1024
    },
    spec = {
      service_name      = "spec"
      path_patterns     = ["/spec", "/spec/*"]
      health_check_path = "/spec/health"
      priority          = 40
      ecr_repository_name = "sq-spec-portal-backend-spec-repos-staging"
      container_port      = 5013
      cpu                 = 512
      memory              = 1024
    },
    snapshot = {
      service_name      = "snapshot"
      path_patterns     = ["/snapshot", "/snapshot/*"]
      health_check_path = "/snapshot/health"
      priority          = 50
      ecr_repository_name = "sq-spec-portal-backend-snapshot-repos-staging"
      container_port      = 5014
      cpu                 = 512
      memory              = 1024
    }
  }
}

variable "task_cpu" {
  description = "Fargate task CPU units per service task. 512 = 0.5 vCPU."
  type        = number
  default     = 2048
}

variable "task_memory" {
  description = "Fargate task memory in MB per service task."
  type        = number
  default     = 4096
}

variable "app_cpu" {
  description = "CPU units reserved for the Django app container."
  type        = number
  default     = 512
}

variable "app_memory" {
  description = "Memory (MB) reserved for the Django app container."
  type        = number
  default     = 1024
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
  description = "Name of the GitHub Actions OIDC role (from staging/github-oidc) that runs `terraform apply` against this module."
  type        = string
  default     = "sq-spec-portal-github-actions-role-staging"
}

variable "alb_log_bucket_name" {
  description = "Name of the S3 bucket to store ALB access logs."
  type        = string
  default     = "sq-spec-portal-backend-elb-log-staging"
}
