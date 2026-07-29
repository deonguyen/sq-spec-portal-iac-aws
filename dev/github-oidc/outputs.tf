output "oidc_provider_arn" {
  description = "The ARN of the OIDC provider for GitHub Actions."
  value       = aws_iam_openid_connect_provider.github_actions.arn
}

output "github_actions_role_arn" {
  description = "The ARN of the IAM role for GitHub Actions."
  value       = aws_iam_role.github_actions_role.arn
}