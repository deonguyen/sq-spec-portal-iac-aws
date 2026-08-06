data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

data "aws_iam_policy_document" "github_actions_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions_role" {
  name               = "${var.github_repo}-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_policy.json
  description        = "IAM role for GitHub Actions to assume"
}

resource "aws_iam_policy" "github_actions_policy" {
  count = length(var.allowed_secret_arns) > 0 || length(var.allowed_s3_bucket_arns) > 0 ? 1 : 0

  name        = "${var.github_repo}-github-actions-policy"
  description = "Policy for the GitHub Actions role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      var.allowed_secret_arns != null && length(var.allowed_secret_arns) > 0 ? [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.allowed_secret_arns
      }] : [],
      var.allowed_s3_bucket_arns != null && length(var.allowed_s3_bucket_arns) > 0 ? [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = var.allowed_s3_bucket_arns
      }] : [],
      var.allowed_s3_bucket_arns != null && length(var.allowed_s3_bucket_arns) > 0 ? [
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = [for arn in var.allowed_s3_bucket_arns : "${arn}/*"]
      }] : []
    )
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_policy_attachment" {
  count = length(var.allowed_secret_arns) > 0 || length(var.allowed_s3_bucket_arns) > 0 ? 1 : 0

  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_policy[0].arn
}
