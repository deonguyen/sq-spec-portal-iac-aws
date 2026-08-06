provider "aws" {
  region = var.aws_region
}

# Use an existing S3 bucket to store the Python packages.
data "aws_s3_bucket" "pypi_bucket" {
  bucket = var.bucket_name
}

# Block all public access to the S3 bucket.
resource "aws_s3_bucket_public_access_block" "pypi_bucket_public_access" {
  bucket = data.aws_s3_bucket.pypi_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning on the S3 bucket to keep a history of your packages.
resource "aws_s3_bucket_versioning" "pypi_bucket_versioning" {
  bucket = data.aws_s3_bucket.pypi_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create a CloudFront Origin Access Control (OAC)
resource "aws_cloudfront_origin_access_control" "pypi_oac" {
  name                              = "${var.bucket_name}-oac"
  description                       = "OAC for PyPI S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Create a CloudFront distribution to serve the packages.
resource "aws_cloudfront_distribution" "pypi_distribution" {
  origin {
    domain_name              = data.aws_s3_bucket.pypi_bucket.bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.pypi_oac.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "PyPI server distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.bucket_name}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Project   = "Private PyPI"
    ManagedBy = "Terraform"
  }
}