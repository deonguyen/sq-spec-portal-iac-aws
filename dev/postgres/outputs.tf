output "db_password" {
  description = "The password for the database."
  value       = random_password.password.result
  sensitive   = true
}