resource "aws_iam_group" "user_group" {
  name = var.iam_group_name
  path = "/system/"
}

resource "aws_iam_group_membership" "group_membership" {
  name  = "spec-portal-backend-iam-user-group-membership-dev"
  group = aws_iam_group.user_group.name
  users = [var.iam_user_name]
}

resource "aws_iam_policy" "group_policy" {
  name        = "${var.iam_group_name}-policy"
  description = "Policy for group ${var.iam_group_name} to access secrets and RDS."
  path        = "/system/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          var.db_credentials_secret_arn
        ]
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "group_policy_attachment" {
  group      = aws_iam_group.user_group.name
  policy_arn = aws_iam_policy.group_policy.arn
}