resource "aws_secretsmanager_secret" "db_user_secret" {
  name = var.secret_name
  recovery_window_in_days = 0 # Set to 0 to allow immediate deletion. For production, consider a value like 7-30.

  lifecycle {
    # When Terraform tries to create a secret that already exists, the AWS provider will gracefully adopt it into the state.
    prevent_destroy = false # Set to true in production if you want to prevent accidental deletion
  }
}

locals {
  secret_arn = aws_secretsmanager_secret.db_user_secret.arn
}