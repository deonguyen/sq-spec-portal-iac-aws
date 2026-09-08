# IAM role assumed by ECS at task launch to pull images from ECR and write logs.
resource "aws_iam_role" "task_execution_role" {
  name = "backend-task-execution-role-staging"

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

resource "aws_iam_role_policy_attachment" "task_execution_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.task_execution_role.name
}

# IAM role assumed by the running Django containers. Attach app-specific
# policies here (S3, SQS, Secrets Manager, etc.). Shared across all services.
resource "aws_iam_role" "task_role" {
  name = "backend-task-role-staging"

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

# IAM policy to allow ECS Exec.
data "aws_iam_policy_document" "ecs_exec_policy_document" {
  statement {
    sid    = "AllowEcsExec"
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_exec_policy" {
  name        = "backend-ecs-exec-policy-staging"
  description = "Allows ECS Exec access to the container."
  policy      = data.aws_iam_policy_document.ecs_exec_policy_document.json
}

resource "aws_iam_role_policy_attachment" "ecs_exec_policy_attachment" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.ecs_exec_policy.arn
}

data "aws_iam_policy_document" "github_actions_ecs_policy_document" {
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
      "arn:aws:iam::885388406688:role/backend-task-execution-role-staging",
      "arn:aws:iam::885388406688:role/backend-task-role-staging",
    ]
  }

  statement {
    sid    = "IamPassTaskRoles"
    effect = "Allow"
    actions = [
      "iam:PassRole",
    ]
    resources = [
      "arn:aws:iam::885388406688:role/backend-task-execution-role-staging",
      "arn:aws:iam::885388406688:role/backend-task-role-staging",
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }

  statement {
    sid    = "TerraformStateBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::sq-spec-portal-tfstate",
      "arn:aws:s3:::sq-spec-portal-tfstate/*",
    ]
  }

  # ECR docker login. GetAuthorizationToken is account-wide by AWS design and
  # cannot be scoped to a specific repository ARN.
  statement {
    sid    = "EcrAuth"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = ["*"]
  }

  # ECR pull/push scoped to every Django app repo.
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
    resources = [for repo in data.aws_ecr_repository.app : repo.arn]
  }
}

resource "aws_iam_policy" "github_actions_ecs_policy" {
  name        = "backend-github-actions-policy-staging"
  description = "Allows the GitHub Actions OIDC role to manage this ECS gateway stack via Terraform."
  policy      = data.aws_iam_policy_document.github_actions_ecs_policy_document.json
}

resource "aws_iam_role_policy_attachment" "github_actions_ecs_policy_attachment" {
  role       = var.github_actions_role_name
  policy_arn = aws_iam_policy.github_actions_ecs_policy.arn
}
