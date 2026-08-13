variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "queue_name" {
  description = "The name of the SQS queue for webhook events."
  type        = string
  default     = "sq-spec-portal-backend-webhook-sqs"
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue (in seconds)."
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message."
  type        = number
  default     = 345600
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it."
  type        = number
  default     = 262144
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed."
  type        = number
  default     = 0
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling)."
  type        = number
  default     = 20
}

variable "max_receive_count" {
  description = "The number of times a consumer can receive a message before it is moved to the dead-letter queue."
  type        = number
  default     = 5
}
