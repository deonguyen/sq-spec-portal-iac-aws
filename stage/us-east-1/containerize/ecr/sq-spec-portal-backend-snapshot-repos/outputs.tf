output "repository_urls" {
  description = "Map of repository name to repository URL."
  value       = { for name, repo in aws_ecr_repository.snapshot : name => repo.repository_url }
}

output "repository_arns" {
  description = "Map of repository name to repository ARN."
  value       = { for name, repo in aws_ecr_repository.snapshot : name => repo.arn }
}

output "registry_ids" {
  description = "Map of repository name to registry ID."
  value       = { for name, repo in aws_ecr_repository.snapshot : name => repo.registry_id }
}
