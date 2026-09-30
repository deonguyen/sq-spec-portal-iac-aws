resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?" # Excludes problematic database characters
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "sq-spec-portal-db-stage-credentials"
  description = "Credentials for the PostgreSQL database."

  tags = {
    Name        = "sq-spec-portal-db-stage-credentials"
    Environment = "stage"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.password.result
  })
}

resource "aws_security_group" "db_sg" {
  name        = "sq-spec-portal-db-stage-sg"
  description = "Allow inbound traffic to PostgreSQL DB"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound rule for PostgreSQL
  ingress {
    description = "Allow PostgreSQL traffic"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule allowing all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sq-spec-portal-db-stage-sg"
    Environment = "stage"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "sq-spec-portal-db-stage-subnet-group"
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  tags = {
    Name = "sq-spec-portal-db-stage-subnet-group"
  }
}

resource "aws_db_instance" "default" {
  identifier             = "sq-spec-portal-db-stage"
  engine                 = "postgres"
  engine_version         = "17"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = true
  db_name                = var.db_name
  username               = var.db_username
  password               = random_password.password.result

  # Set to 'false' for production environments to ensure a final snapshot is created upon deletion.
  skip_final_snapshot = true

  tags = {
    Name        = "sq-spec-portal-db-stage"
    Environment = "stage"
  }
}
