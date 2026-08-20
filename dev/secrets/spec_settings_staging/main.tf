resource "aws_secretsmanager_secret" "spec_settings_secret" {
  name        = var.secret_name
  description = "Specification settings for the staging environment."

  # For development environments, allow immediate deletion.
  # In production, consider a value like 7-30 days to prevent accidental data loss.
  recovery_window_in_days = 0

  lifecycle {
    # For development environments, allow destruction.
    # In production, set to true to prevent accidental deletion of the secret.
    prevent_destroy = false
  }
}

resource "aws_secretsmanager_secret_version" "spec_settings_version" {
  secret_id     = aws_secretsmanager_secret.spec_settings_secret.id
  # Store the specification settings map as a JSON string in the secret.
  secret_string = jsonencode(var.spec_settings)
}

output "secret_arn" {
  description = "The ARN of the created Secrets Manager secret."
  value       = aws_secretsmanager_secret.spec_settings_secret.arn
}

output "secret_name" {
  description = "The name of the created Secrets Manager secret."
  value       = aws_secretsmanager_secret.spec_settings_secret.name
}