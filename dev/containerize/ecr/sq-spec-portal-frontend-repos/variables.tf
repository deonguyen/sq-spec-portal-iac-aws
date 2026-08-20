variable "repository_names" {
  description = "List of ECR static server repositories to provision."
  type        = list(string)
  default = [
    "sq-spec-portal-frontend-repos",
  ]
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repositories (MUTABLE or IMMUTABLE)."
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Whether images are scanned after being pushed to the repository."
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "The encryption type to use for the repositories (AES256 or KMS)."
  type        = string
  default     = "AES256"
}

variable "untagged_image_expiry_days" {
  description = "Number of days after which untagged images are expired by the lifecycle policy. Set to 0 to disable."
  type        = number
  default     = 14
}

variable "max_tagged_image_count" {
  description = "Maximum number of tagged images to retain per repository. Set to 0 to disable."
  type        = number
  default     = 50
}
