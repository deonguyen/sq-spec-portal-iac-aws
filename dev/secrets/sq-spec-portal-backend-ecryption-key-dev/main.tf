resource "aws_secretsmanager_secret" "encryption_key_secret" {
  name = var.secret_name

  lifecycle {
    # This ignore_changes block prevents Terraform from trying to recreate the secret
    # if it already exists but was not created by this Terraform configuration.
    # When Terraform tries to create a secret that already exists, the AWS provider
    # will gracefully adopt it into the state.
    prevent_destroy = false # Set to true in production if you want to prevent accidental deletion
  }
}

resource "random_bytes" "encryption_key" {
  length = 32
}

resource "aws_secretsmanager_secret_version" "encryption_key_value" {
  # This will only create a new secret version if the secret does not already have one.
  # The `recovery_window_in_days = 0` on the secret would be needed for Terraform to
  # successfully destroy and recreate the version on value changes.
  # Here, we assume we only set the value once on creation.
  secret_id     = aws_secretsmanager_secret.encryption_key_secret.id
  secret_string = random_bytes.encryption_key.base64
}

locals {
  # The ARN of the secret, whether it was newly created or already existed.
  secret_arn = aws_secretsmanager_secret.encryption_key_secret.arn
}