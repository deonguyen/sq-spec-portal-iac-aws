output "cluster_endpoint" {
  description = "Endpoint for your EKS cluster."
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
  description = "The name of your EKS cluster."
  value       = aws_eks_cluster.eks_cluster.name
}