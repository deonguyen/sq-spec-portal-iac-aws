resource "aws_iam_group" "user_group" {
  name = var.iam_group_name
  path = "/system/"
}

resource "aws_iam_group_membership" "group_membership" {
  name  = "spec-portal-backend-iam-user-group-membership-dev"
  group = aws_iam_group.user_group.name
  users = [var.iam_user_name]
}

resource "aws_iam_group_policy_attachment" "group_policy_attachment" {
  group      = aws_iam_group.user_group.name
  policy_arn = aws_iam_policy.group_policy.arn
}

resource "aws_iam_policy" "group_policy" {
  name        = "${var.iam_group_name}-policy"
  description = "Policy for the ${var.iam_group_name} group"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Effect   = "Allow"
        Resource = "*" # It's better to restrict this to specific secret ARNs in production
      },
      {
        Action = [
          "rds-db:connect"
        ]
        Effect   = "Allow"
        Resource = "*" # It's better to restrict this to the specific DB user ARN in production
      },
      {
        Action = [
          "sqs:SendMessage",
          "sqs:SendMessageBatch",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:DeleteMessageBatch",
          "sqs:ChangeMessageVisibility",
          "sqs:ChangeMessageVisibilityBatch",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ListQueues",
          "sqs:ListQueueTags",
          "sqs:ListDeadLetterSourceQueues"
        ]
        Effect   = "Allow"
        Resource = "*" # It's better to restrict this to the specific SQS queue ARNs in production
      }
    ]
  })
}