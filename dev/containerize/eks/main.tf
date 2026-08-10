resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
 
  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }
 
  access_config {
    bootstrap_cluster_creator_admin_permissions = true
  }
 
  # Authorize the GitHub Actions role to access the cluster
  aws_auth_additional_config = jsonencode({
    mapRoles = [
      { "rolearn" : aws_iam_role.github_actions_eks_deploy_role.arn, "username" : "github-actions", "groups" : ["system:masters"] }
    ]
  })
 
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
  ]
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = module.vpc.private_subnets
  instance_types  = var.instance_types

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
  ]
}