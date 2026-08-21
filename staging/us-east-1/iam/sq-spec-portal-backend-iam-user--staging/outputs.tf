output "user_arn" {
  description = "The ARN of the created IAM user."
  value       = aws_iam_user.user.arn
}

output "access_key_id" {
  description = "The access key ID for the IAM user."
  value       = aws_iam_access_key.user_key.id
}

output "secret_access_key" {
  description = "The secret access key for the IAM user. This is sensitive and should be stored securely."
  value       = aws_iam_access_key.user_key.secret
  sensitive   = true
}