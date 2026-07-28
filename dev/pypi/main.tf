resource "aws_s3_bucket" "pypi_packages" {
  bucket = var.pypi_bucket_name

  tags = {
    Name = var.pypi_bucket_name
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "pypi_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.pypi_server_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.pypi_server_instance_profile.name
  user_data_replace_on_change = true
  user_data = templatefile("${path.module}/user_data.sh", {
    pypi_bucket_name = aws_s3_bucket.pypi_packages.bucket
    aws_region       = var.aws_region,
    pypi_user        = var.pypi_admin_user,
    pypi_password    = var.pypi_admin_password
  })

  tags = {
    Name = "${var.project_name}-instance"
  }
}