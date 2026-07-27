resource "random_password" "password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.db_name}-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.password.result
    engine   = "postgres"
    host     = aws_db_instance.default.address
    port     = aws_db_instance.default.port
    dbname   = var.db_name
  })
}

resource "aws_db_instance" "default" {
  identifier           = "spec-portal-postgres-dev"
  engine               = "postgres"
  engine_version       = "17"
  instance_class       = var.db_instance_class
  allocated_storage    = 20
  db_name              = var.db_name
  username             = var.db_username
  password             = random_password.password.result
  publicly_accessible  = true

  # Set to 'false' for production environments to ensure a final snapshot is created upon deletion.
  skip_final_snapshot = true

  tags = {
    Name        = "spec-portal-postgres-dev"
    Environment = "dev"
  }
}