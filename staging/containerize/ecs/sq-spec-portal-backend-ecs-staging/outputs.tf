output "cluster_arn" {
  description = "The ARN of the ECS cluster."
  value       = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  description = "The name of the ECS cluster."
  value       = aws_ecs_cluster.this.name
}

output "service_names" {
  description = "Map of service key to ECS service name."
  value       = { for k, s in aws_ecs_service.this : k => s.name }
}

output "service_arns" {
  description = "Map of service key to ECS service ARN."
  value       = { for k, s in aws_ecs_service.this : k => s.id }
}

output "task_definition_arns" {
  description = "Map of service key to task definition ARN (app container only)."
  value       = { for k, t in aws_ecs_task_definition.this : k => t.arn }
}

output "task_execution_role_arn" {
  description = "ARN of the IAM role ECS uses to pull images and write logs."
  value       = aws_iam_role.task_execution_role.arn
}

output "task_role_arn" {
  description = "ARN of the IAM role assumed by the containers at runtime."
  value       = aws_iam_role.task_role.arn
}

output "alb_dns_name" {
  description = "Public DNS name of the ALB gateway."
  value       = aws_lb.this.dns_name
}

output "gateway_url" {
  description = "Public HTTP URL of the ALB gateway (path-routed to each backend)."
  value       = "http://${aws_lb.this.dns_name}"
}

output "service_urls" {
  description = "Map of service key to a representative public URL routed through the ALB."
  value = {
    for k, s in var.services :
    k => "http://${aws_lb.this.dns_name}${s.path_patterns[0]}"
  }
}

output "log_group_names" {
  description = "Map of service key to CloudWatch log group receiving app container logs."
  value       = { for k, lg in aws_cloudwatch_log_group.this : k => lg.name }
}
