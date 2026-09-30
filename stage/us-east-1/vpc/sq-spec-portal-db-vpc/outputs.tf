output "vpc_id" {
  description = "The ID of the DB VPC."
  value       = aws_vpc.db_vpc.id
}

output "vpc_cidr" {
  description = "The CIDR block of the DB VPC."
  value       = aws_vpc.db_vpc.cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets."
  value       = aws_subnet.public[*].id
}