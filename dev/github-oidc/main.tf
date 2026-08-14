data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/stargate"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com/stargate"

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
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = var.allowed_github_subs
    }
  }
}

resource "aws_iam_role" "github_actions_role" {
  name               = "${var.github_repo}-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_policy.json
  description        = "IAM role for GitHub Actions to assume"
}

locals {
  has_ecr           = length(var.allowed_ecr_repository_arns) > 0
  has_eks           = length(var.allowed_eks_cluster_arns) > 0
  has_pass_role     = length(var.allowed_pass_role_arns) > 0
  has_inline_policy = length(var.allowed_secret_arns) > 0 || length(var.allowed_s3_bucket_arns) > 0 || local.has_ecr || local.has_eks || local.has_pass_role
}

resource "aws_iam_policy" "github_actions_policy" {
  count = local.has_inline_policy ? 1 : 0

  name        = "${var.github_repo}-github-actions-policy"
  description = "Policy for the GitHub Actions role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      length(var.allowed_secret_arns) > 0 ? [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.allowed_secret_arns
      }] : [],
      length(var.allowed_s3_bucket_arns) > 0 ? [
      {
        Effect = "Allow"
        Action = ["s3:ListBucket"]
        Resource = var.allowed_s3_bucket_arns
      }] : [],
      length(var.allowed_s3_bucket_arns) > 0 ? [
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = [for arn in var.allowed_s3_bucket_arns : "${arn}/*"]
      }] : [],
      local.has_ecr ? [
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      }] : [],
      local.has_ecr ? [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:ListImages",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = var.allowed_ecr_repository_arns
      }] : [],
      local.has_eks ? [
      {
        Effect   = "Allow"
        Action   = ["eks:DescribeCluster", "eks:ListClusters"]
        Resource = var.allowed_eks_cluster_arns
      }] : [],
      local.has_pass_role ? [
      {
        Effect   = "Allow"
        Action   = ["iam:PassRole"]
        Resource = var.allowed_pass_role_arns
        Condition = {
          StringEquals = {
            "iam:PassedToService" = "ecs-tasks.amazonaws.com"
          }
        }
      }] : []
    )
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_policy_attachment" {
  count = local.has_inline_policy ? 1 : 0

  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_policy[0].arn
}