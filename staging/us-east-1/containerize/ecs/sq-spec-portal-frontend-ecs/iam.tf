# IAM role assumed by ECS at task launch to pull the image from ECR and write logs.
resource "aws_iam_role" "task_execution_role" {
  name = "sq-spec-portal-frontend-ecs-task-execution-role-staging"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.task_execution_role.name
}

# IAM role assumed by the running Next.js container. Attach app-specific policies here (e.g. for S3, etc.).
resource "aws_iam_role" "task_role" {
  name = "sq-spec-portal-frontend-ecs-task-role-staging"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

# Grant the GitHub Actions OIDC role permission to run `terraform apply` against this module.
data "aws_iam_policy_document" "github_actions_ecs_manage" {
  statement {
    sid    = "EcsManage"
    effect = "Allow"
    actions = [
      "ecs:*",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ElbManage"
    effect = "Allow"
    actions = [
      "elasticloadbalancing:*",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Ec2VpcManage"
    effect = "Allow"
    actions = [
      "ec2:*",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "LogsManage"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:DescribeLogGroups",
      "logs:PutRetentionPolicy",
      "logs:DeleteRetentionPolicy",
      "logs:TagResource",
      "logs:UntagResource",
      "logs:ListTagsForResource",
      "logs:ListTagsLogGroup",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "IamManageServiceRoles"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:UpdateRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:GetRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:ListRoleTags",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/sq-spec-portal-frontend-ecs-task-execution-role-staging",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/sq-spec-portal-frontend-ecs-task-role-staging",
    ]
  }

  statement {
    sid    = "IamPassTaskRoles"
    effect = "Allow"
    actions = [
      "iam:PassRole",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/sq-spec-portal-frontend-ecs-task-execution-role-staging",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/sq-spec-portal-frontend-ecs-task-role-staging",
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }

  # ECR docker login.
  statement {
    sid    = "EcrAuth"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = ["*"]
  }

  # ECR build/push + pull, scoped to the repository backing this service.
  statement {
    sid    = "EcrRepo"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
    resources = [data.aws_ecr_repository.app.arn]
  }
}

resource "aws_iam_policy" "github_actions_ecs_manage" {
  name        = "sq-spec-portal-frontend-ecs-github-actions-manage-staging"
  description = "Allows the GitHub Actions OIDC role to manage this ECS service via Terraform."
  policy      = data.aws_iam_policy_document.github_actions_ecs_manage.json
}

resource "aws_iam_role_policy_attachment" "github_actions_ecs_manage" {
  role       = var.github_actions_role_name
  policy_arn = aws_iam_policy.github_actions_ecs_manage.arn
}