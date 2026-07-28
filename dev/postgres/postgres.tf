resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?" # Excludes problematic database characters
}

resource "aws_db_instance" "default" {
  identifier           = "sq-spec-portal-postgres-dev"
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
    Name        = "sq-spec-portal-postgres-dev"
    Environment = "dev"
  }
}