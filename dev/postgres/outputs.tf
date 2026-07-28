output "db_username" {
  description = "The username for the master database user."
  value       = var.db_username
}

output "db_password" {
  description = "The password for the master database user."
  value       = random_password.password.result
  sensitive   = true
}