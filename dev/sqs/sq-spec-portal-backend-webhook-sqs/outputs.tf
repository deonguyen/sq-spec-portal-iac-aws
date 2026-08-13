output "queue_id" {
  description = "The URL of the SQS queue."
  value       = aws_sqs_queue.webhook_queue.id
}

output "queue_arn" {
  description = "The ARN of the SQS queue."
  value       = aws_sqs_queue.webhook_queue.arn
}

output "queue_name" {
  description = "The name of the SQS queue."
  value       = aws_sqs_queue.webhook_queue.name
}

output "dlq_id" {
  description = "The URL of the SQS dead-letter queue."
  value       = aws_sqs_queue.webhook_dlq.id
}

output "dlq_arn" {
  description = "The ARN of the SQS dead-letter queue."
  value       = aws_sqs_queue.webhook_dlq.arn
}
