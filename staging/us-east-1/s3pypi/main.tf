provider "aws" {
  region = var.aws_region
}

# Create a CloudFront Origin Access Control (OAC)
resource "aws_cloudfront_origin_access_control" "pypi_oac" {
  name                              = "s3pypi-oac-staging"
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
