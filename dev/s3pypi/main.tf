provider "aws" {
  region = var.aws_region
}

# Create an S3 bucket to store the Python packages.
resource "aws_s3_bucket" "pypi_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "PyPI Server"
    Project     = "Private PyPI"
    ManagedBy   = "Terraform"
  }
}

# Block all public access to the S3 bucket.
resource "aws_s3_bucket_public_access_block" "pypi_bucket_public_access" {
  bucket = aws_s3_bucket.pypi_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning on the S3 bucket to keep a history of your packages.
resource "aws_s3_bucket_versioning" "pypi_bucket_versioning" {
  bucket = aws_s3_bucket.pypi_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create an IAM user for uploading packages to the S3 bucket.
resource "aws_iam_user" "pypi_uploader" {
  name = var.iam_user_name
  path = "/system/"
}

# Generate access keys for the IAM user.
# These keys will be used to configure your local environment for publishing.
resource "aws_iam_access_key" "pypi_uploader_keys" {
  user = aws_iam_user.pypi_uploader.name
}

# Define an IAM policy that grants the necessary permissions for s3pypi.
data "aws_iam_policy_document" "pypi_policy_doc" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      aws_s3_bucket.pypi_bucket.arn,
      "${aws_s3_bucket.pypi_bucket.arn}/*",
    ]
  }
}

# Attach the policy to the IAM user.
resource "aws_iam_user_policy" "pypi_policy_attachment" {
  name   = "s3pypi-policy"
  user   = aws_iam_user.pypi_uploader.name
  policy = data.aws_iam_policy_document.pypi_policy_doc.json
}

# Create a CloudFront Origin Access Control (OAC)
resource "aws_cloudfront_origin_access_control" "pypi_oac" {
  name                              = "${var.bucket_name}-oac"
  description                       = "OAC for PyPI S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Add a bucket policy to allow CloudFront to get objects
resource "aws_s3_bucket_policy" "pypi_bucket_policy" {
  bucket = aws_s3_bucket.pypi_bucket.id
  policy = data.aws_iam_policy_document.cloudfront_policy_doc.json
}

data "aws_iam_policy_document" "cloudfront_policy_doc" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.pypi_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.pypi_distribution.arn]
    }
  }
}

# Create a CloudFront distribution to serve the packages.
resource "aws_cloudfront_distribution" "pypi_distribution" {
  origin {
    domain_name              = aws_s3_bucket.pypi_bucket.bucket_regional_domain_name
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