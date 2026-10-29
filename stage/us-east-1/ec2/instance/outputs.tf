output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "The ARN of the EC2 instance."
  value       = aws_instance.this.arn
}

output "private_ip" {
  description = "The private IP address of the EC2 instance."
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "The public IP address of the EC2 instance (if assigned)."
  value       = aws_instance.this.public_ip
}

output "ami_id" {
  description = "The AMI ID used to launch the instance."
  value       = data.aws_ami.amazon_linux_2023.id
}

output "subnet_id" {
  description = "The subnet ID where the EC2 instance is deployed."
  value       = aws_instance.this.subnet_id
}

output "security_group_id" {
  description = "The ID of the security group attached to the EC2 instance."
  value       = aws_security_group.bastion.id
}