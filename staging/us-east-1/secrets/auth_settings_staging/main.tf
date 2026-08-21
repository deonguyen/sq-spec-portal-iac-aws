resource "aws_secretsmanager_secret" "auth_settings_secret" {
  name        = var.secret_name
  description = "Authentication settings for the staging environment."

  # For stagingelopment environments, allow immediate deletion.
  # In production, consider a value like 7-30 days to prevent accidental data loss.
  recovery_window_in_days = 0

  lifecycle {
    # For stagingelopment environments, allow destruction.
    # In production, set to true to prevent accidental deletion of the secret.
    prevent_destroy = false
  }
}

resource "aws_secretsmanager_secret_version" "auth_settings_version" {
  secret_id     = aws_secretsmanager_secret.auth_settings_secret.id
  # Store the authentication settings map as a JSON string.
  secret_string = jsonencode(var.auth_settings)
}

output "secret_arn" {
  description = "The ARN of the created Secrets Manager secret."
  value       = aws_secretsmanager_secret.auth_settings_secret.arn
}

output "secret_name" {
  description = "The name of the created Secrets Manager secret."
  value       = aws_secretsmanager_secret.auth_settings_secret.name
}