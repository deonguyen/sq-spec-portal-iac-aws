data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "${path.module}/${var.vpc_state_path}"
  }
}

locals {
  subnet_id = var.subnet_id != null ? var.subnet_id : try(
    var.associate_public_ip_address ? data.terraform_remote_state.vpc.outputs.public_subnets[0] : data.terraform_remote_state.vpc.outputs.private_subnets[0],
    data.terraform_remote_state.vpc.outputs.private_subnets[0],
    data.terraform_remote_state.vpc.outputs.public_subnets[0],
    data.terraform_remote_state.vpc.outputs.subnet_ids[0],
    null
  )
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_security_group" "bastion" {
  name        = "${var.instance_name}-sg"
  description = "Security group for EC2 instance to allow SSH and RDS tunneling"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic (including PostgreSQL port 5432)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.instance_name}-sg"
    ManagedBy = "Terraform"
  }
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = distinct(concat([aws_security_group.bastion.id], var.vpc_security_group_ids))
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # Enforce IMDSv2
    http_put_response_hop_limit = 1
  }

  tags = {
    Name      = var.instance_name
    ManagedBy = "Terraform"
  }
}