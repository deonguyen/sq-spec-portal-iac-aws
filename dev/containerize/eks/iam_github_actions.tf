# IAM Role for GitHub Actions to deploy to EKS

data "aws_iam_policy_document" "github_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.github_oidc_provider_arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions_eks_deploy_role" {
  name               = "${var.cluster_name}-github-actions-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role_policy.json
  description        = "Role for GitHub Actions to deploy to the EKS cluster."
}

resource "aws_iam_role_policy" "github_actions_eks_deploy_policy" {
  name = "${var.cluster_name}-github-actions-eks-deploy-policy"
  role = aws_iam_role.github_actions_eks_deploy_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "eks:DescribeCluster"
        Effect   = "Allow"
        Resource = aws_eks_cluster.eks_cluster.arn
      },
      {
        Action   = "sts:AssumeRole"
        Effect   = "Allow"
        Resource = aws_iam_role.eks_node_group_role.arn
      }
    ]
  })
}