resource "aws_secretsmanager_secret" "settings_secret" {
  name        = var.secret_name
  description = "Application settings for the staging environment."

  # For stagingelopment environments, allow immediate deletion.
  # In production, consider a value like 7-30 days to prevent accidental data loss.
  recovery_window_in_days = 0

  lifecycle {
    # For stagingelopment environments, allow destruction.
    # In production, set to true to prevent accidental deletion of the secret.
    prevent_destroy = false
  }
}

resource "aws_secretsmanager_secret_version" "settings_secret_version" {
  secret_id     = aws_secretsmanager_secret.settings_secret.id
  # Store the structured settings object as a JSON string in the secret.
  secret_string = jsonencode(var.admin_settings)
}

output "secret_arn" {
  description = "The ARN of the created Secrets Manager secret."
  value       = aws_secretsmanager_secret.settings_secret.arn
}

output "secret_name" {
  description = "The name of the created Secrets Manager secret."
  value       = aws_secretsmanager_secret.settings_secret.name
}