resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?" # Excludes problematic database characters
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "sq-spec-portal-postgres-staging-credentials"
  description = "Credentials for the PostgreSQL database."

  tags = {
    Name        = "sq-spec-portal-postgres-staging-credentials"
    Environment = "staging"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.password.result
  })
}

resource "aws_security_group" "db" {
  name        = "sq-spec-portal-postgres-staging-sg"
  description = "Allow inbound traffic to PostgreSQL DB"

  ingress {
    description = "Allow PostgreSQL traffic from anywhere"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.db_allowed_cidr_blocks
  }

  tags = {
    Name        = "sq-spec-portal-postgres-staging-sg"
    Environment = "staging"
  }
}

resource "aws_db_instance" "default" {
  identifier           = "sq-spec-portal-postgres-staging"
  engine               = "postgres"
  engine_version       = "17"
  instance_class       = var.db_instance_class
  allocated_storage    = 20
  vpc_security_group_ids = [aws_security_group.db.id]
  db_name              = var.db_name
  username             = var.db_username
  password             = random_password.password.result
  publicly_accessible  = true

  # Set to 'false' for production environments to ensure a final snapshot is created upon deletion.
  skip_final_snapshot = true

  tags = {
    Name        = "sq-spec-portal-postgres-staging"
    Environment = "staging"
  }
}