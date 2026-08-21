variable "aws_account_id" {
  description = "The AWS account ID where resources will be created."
  type        = string
  default     = "885388406688" # TODO: update with your AWS account ID
}

variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "backend_bucket" {
  description = "The S3 bucket name for storing Terraform state."
  type        = string
  default     = "sq-spec-portal-tfstate" # TODO: update with your S3 bucket name
}

variable "allowed_github_subs" {
  description = "A list of GitHub OIDC `sub` claim patterns allowed to assume the role (e.g. `repo:org/repo:ref:refs/heads/main`, `repo:org/repo:environment:production`). Must be scoped — full wildcards like `repo:org/repo:*` are rejected by account SCP."
  type        = list(string)
  default = [
    "repo:deonguyen/sq-spec-portal-backend:ref:refs/heads/*",
    "repo:deonguyen/sq-spec-portal-frontend:ref:refs/heads/*", # Replaced with static values
  ]
}

variable "allowed_secret_arns" {
  description = "A list of secret ARNs that GitHub Actions is allowed to access."
  type        = list(string)
  default     = []
}

variable "allowed_s3_bucket_arns" {
  description = "A list of S3 bucket ARNs that GitHub Actions is allowed to access."
  type        = list(string)
  default     = []
}

variable "allowed_ecr_repository_arns" {
  description = "A list of ECR repository ARNs GitHub Actions is allowed to build and push to."
  type        = list(string)
  default = [
    "arn:aws:ecr:us-east-1:885388406688:repository/sq-spec-portal-backend-admin-repos-staging",
    "arn:aws:ecr:us-east-1:885388406688:repository/sq-spec-portal-backend-auth-repos-staging",
    "arn:aws:ecr:us-east-1:885388406688:repository/sq-spec-portal-backend-spec-repos-staging",
    "arn:aws:ecr:us-east-1:885388406688:repository/sq-spec-portal-backend-snapshot-repos-staging",
    "arn:aws:ecr:us-east-1:885388406688:repository/sq-spec-portal-backend-static-repos-staging",
    "arn:aws:ecr:us-east-1:885388406688:repository/sq-spec-portal-frontend-repos-staging",
  ]
}

variable "allowed_eks_cluster_arns" {
  description = "A list of EKS cluster ARNs GitHub Actions is allowed to describe (needed for `aws eks update-kubeconfig`). NOTE: cluster-side access (aws-auth ConfigMap or EKS access entries) must be configured separately."
  type        = list(string)
  default     = [
    "arn:aws:eks:us-east-1:885388406688:cluster/backend-cluster-staging",
    "arn:aws:eks:us-east-1:885388406688:cluster/frontend-cluster-staging",
  ]
}

variable "allowed_pass_role_arns" {
  description = "IAM role ARNs GitHub Actions can pass (iam:PassRole) to ecs-tasks.amazonaws.com. Required for `RegisterTaskDefinition` to reference a task role and execution role."
  type        = list(string)
  default = [
    "arn:aws:iam::885388406688:role/sq-spec-portal-backend-ecs-task-role-staging",
    "arn:aws:iam::885388406688:role/sq-spec-portal-backend-ecs-task-execution-role-staging",
    "arn:aws:iam::885388406688:role/sq-spec-portal-frontend-ecs-task-role-staging",
    "arn:aws:iam::885388406688:role/sq-spec-portal-frontend-ecs-task-execution-role-staging",
  ]
}
