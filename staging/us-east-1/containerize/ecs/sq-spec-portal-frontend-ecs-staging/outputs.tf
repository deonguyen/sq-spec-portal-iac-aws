output "cluster_arn" {
  description = "The ARN of the ECS cluster."
  value       = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  description = "The name of the ECS cluster."
  value       = aws_ecs_cluster.this.name
}

output "service_name" {
  description = "The name of the ECS service."
  value       = aws_ecs_service.this.name
}

output "service_arn" {
  description = "The ARN of the ECS service."
  value       = aws_ecs_service.this.id
}

output "task_definition_arn" {
  description = "The ARN of the ECS task definition running the Next.js app."
  value       = aws_ecs_task_definition.this.arn
}

output "task_execution_role_arn" {
  description = "ARN of the IAM role ECS uses to pull the image and write logs."
  value       = aws_iam_role.task_execution_role.arn
}

output "task_role_arn" {
  description = "ARN of the IAM role assumed by the Next.js container at runtime."
  value       = aws_iam_role.task_role.arn
}

output "alb_dns_name" {
  description = "Public DNS name of the ALB fronting the Next.js app."
  value       = aws_lb.this.dns_name
}

output "app_url" {
  description = "Public HTTP URL of the Next.js app served via the ALB."
  value       = "http://${aws_lb.this.dns_name}"
}

output "log_group_name" {
  description = "CloudWatch log group receiving Next.js container logs."
  value       = aws_cloudwatch_log_group.this.name
}