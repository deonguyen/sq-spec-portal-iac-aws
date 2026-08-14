resource "aws_secretsmanager_secret" "db_info_secret" {
  name                    = var.secret_name
  recovery_window_in_days = 0 # For dev, set to 7-30 for prod
}

resource "aws_secretsmanager_secret_version" "db_info_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_info_secret.id
  secret_string = jsonencode(var.db_info)

  lifecycle {
    ignore_changes = [secret_string]
  }
}