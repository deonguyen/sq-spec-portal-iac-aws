resource "aws_sqs_queue" "webhook_dlq" {
  name                       = "${var.queue_name}-dlq"
  message_retention_seconds  = var.message_retention_seconds
  sqs_managed_sse_enabled    = true

  tags = {
    Name      = "${var.queue_name}-dlq"
    ManagedBy = "Terraform"
  }
}

resource "aws_sqs_queue" "webhook_queue" {
  name                       = var.queue_name
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  max_message_size           = var.max_message_size
  delay_seconds              = var.delay_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  sqs_managed_sse_enabled    = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.webhook_dlq.arn
    maxReceiveCount     = var.max_receive_count
  })

  tags = {
    Name      = var.queue_name
    ManagedBy = "Terraform"
  }
}

resource "aws_sqs_queue_redrive_allow_policy" "webhook_dlq_redrive_allow" {
  queue_url = aws_sqs_queue.webhook_dlq.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
    sourceQueueArns   = [aws_sqs_queue.webhook_queue.arn]
  })
}
