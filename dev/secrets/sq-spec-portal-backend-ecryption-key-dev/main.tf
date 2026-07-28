
# terraform import aws_secretsmanager_secret.encryption_key_secret arn:aws:secretsmanager:us-east-2:885388406688:secret:sq-spec-portal-backend-ecryption-key-dev-pRQuuM

data "aws_secretsmanager_secret_version" "existing" {
  # This data source will not error if the secret is not found.
  # Instead, its attributes will be null.
  secret_id = var.secret_name
}

resource "aws_secretsmanager_secret" "encryption_key_secret" {
  name = var.secret_name

  lifecycle {
    # When Terraform tries to create a secret that already exists, the AWS provider will gracefully adopt it into the state.
    prevent_destroy = false # Set to true in production if you want to prevent accidental deletion
  }
}

resource "random_bytes" "encryption_key" {
  # This resource will only be used if we need to create a new secret version.
  length = 32
}

resource "aws_secretsmanager_secret_version" "encryption_key_value" {
  # Create a secret version only if the data source did not find an existing one.
  count = data.aws_secretsmanager_secret_version.existing.secret_arn == null ? 1 : 0

  secret_id     = aws_secretsmanager_secret.encryption_key_secret.id
  secret_string = random_bytes.encryption_key.base64
}

locals {
  # Use the ARN from the existing secret if found, otherwise use the ARN from the newly created one.
  # This ensures the output is always correct.
  secret_arn = coalesce(data.aws_secretsmanager_secret_version.existing.secret_arn, aws_secretsmanager_secret.encryption_key_secret.arn)
}