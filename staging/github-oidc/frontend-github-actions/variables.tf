variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = local.aws_region
}

variable "github_org" {
  description = "The GitHub organization."
  type        = string
  default     = local.github_org
}

variable "github_repo" {
  description = "The GitHub repository."
  type        = string
  default     = local.github_repo
}

variable "allowed_github_subs" {
  description = "A list of GitHub OIDC `sub` claim patterns allowed to assume the role (e.g. `repo:org/repo:ref:refs/heads/main`, `repo:org/repo:environment:production`). Must be scoped — full wildcards like `repo:org/repo:*` are rejected by account SCP."
  type        = list(string)
  default = [
    "repo:${local.github_org}/${local.github_repo}:ref:refs/heads/*",
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
    "arn:aws:ecr:${local.aws_region}:${local.aws_account_id}:repository/sq-spec-portal-backend-admin-staging-repos",
    "arn:aws:ecr:${local.aws_region}:${local.aws_account_id}:repository/sq-spec-portal-backend-auth-staging-repos",
    "arn:aws:ecr:${local.aws_region}:${local.aws_account_id}:repository/sq-spec-portal-backend-spec-staging-repos",
    "arn:aws:ecr:${local.aws_region}:${local.aws_account_id}:repository/sq-spec-portal-backend-snapshot-staging-repos",
    "arn:aws:ecr:${local.aws_region}:${local.aws_account_id}:repository/sq-spec-portal-backend-static-staging-repos"
  ]
}

variable "allowed_eks_cluster_arns" {
  description = "A list of EKS cluster ARNs GitHub Actions is allowed to describe (needed for `aws eks update-kubeconfig`). NOTE: cluster-side access (aws-auth ConfigMap or EKS access entries) must be configured separately."
  type        = list(string)
  default     = []
}

variable "allowed_pass_role_arns" {
  description = "IAM role ARNs GitHub Actions can pass (iam:PassRole) to ecs-tasks.amazonaws.com. Required for `RegisterTaskDefinition` to reference a task role and execution role."
  type        = list(string)
  default = [
    "arn:aws:iam::${local.aws_account_id}:role/sq-spec-portal-staging-ecs-task-role-staging",
    "arn:aws:iam::${local.aws_account_id}:role/sq-spec-portal-staging-ecs-task-execution-role-staging",
  ]
}
