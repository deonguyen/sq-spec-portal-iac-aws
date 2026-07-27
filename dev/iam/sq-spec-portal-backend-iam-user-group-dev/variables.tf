variable "iam_group_name" {
  description = "The name of the IAM group."
  type        = string
  default     = "sq-spec-portal-backend-iam-user-group-dev"
}

variable "iam_user_name" {
  description = "The name of the IAM user to add to the group."
  type        = string
  default     = "sq-spec-portal-backend-iam-user-dev"
}