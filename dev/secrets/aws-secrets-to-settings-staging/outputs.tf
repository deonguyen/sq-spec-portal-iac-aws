output "secret_arn" {
  description = "The ARN of the created secret."
  value       = aws_secretsmanager_secret.db_info_secret.arn
}

output "secret_name" {
  description = "The name of the created secret."
  value       = aws_secretsmanager_secret.db_info_secret.name
}