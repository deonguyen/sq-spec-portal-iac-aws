resource "aws_s3_bucket" "pypi_packages_bucket" {
  bucket = var.bucket_name

  tags = {
    Name      = var.bucket_name
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "pypi_packages_bucket_versioning" {
  bucket = aws_s3_bucket.pypi_packages_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pypi_packages_bucket_sse" {
  bucket = aws_s3_bucket.pypi_packages_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "pypi_packages_bucket_public_access" {
  bucket = aws_s3_bucket.pypi_packages_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}