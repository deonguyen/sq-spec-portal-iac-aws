data "aws_secretsmanager_secret" "existing" {
  name = var.secret_name
}

resource "random_bytes" "encryption_key" {
  # Only create random bytes if the secret doesn't exist.
  count  = data.aws_secretsmanager_secret.existing.arn == null ? 1 : 0
  length = 32
}

resource "aws_secretsmanager_secret" "new" {
  # Only create the secret if it doesn't exist.
  count = data.aws_secretsmanager_secret.existing.arn == null ? 1 : 0
  name  = var.secret_name
}

resource "aws_secretsmanager_secret_version" "new" {
  # Only create the secret version if the secret is being created.
  count         = length(aws_secretsmanager_secret.new) > 0 ? 1 : 0
  secret_id     = aws_secretsmanager_secret.new[0].id
  secret_string = random_bytes.encryption_key[0].base64
}

locals {
  # Use the ARN of the existing secret if it's found, otherwise use the ARN of the new one.
  secret_arn = data.aws_secretsmanager_secret.existing.arn != null ? data.aws_secretsmanager_secret.existing.arn : aws_secretsmanager_secret.new[0].arn
}