output "pypi_bucket_name" {
  description = "The name of the S3 bucket for the PyPI server."
  value       = aws_s3_bucket.pypi_bucket.bucket
}

output "aws_iam_user_name" {
  description = "The name of the IAM user created for publishing packages."
  value       = aws_iam_user.pypi_uploader.name
}

output "aws_access_key_id" {
  description = "The access key ID for the PyPI uploader user."
  value       = aws_iam_access_key.pypi_uploader_keys.id
}

output "aws_secret_access_key" {
  description = "The secret access key for the PyPI uploader user. Store this securely!"
  value       = aws_iam_access_key.pypi_uploader_keys.secret
  sensitive   = true
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name of the CloudFront distribution for the PyPI server."
  value       = aws_cloudfront_distribution.pypi_distribution.domain_name
}