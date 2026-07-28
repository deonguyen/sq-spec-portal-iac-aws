resource "aws_iam_role" "pypi_server_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "pypi_server_instance_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.pypi_server_role.name
}

resource "aws_iam_policy" "pypi_s3_policy" {
  name        = "${var.project_name}-s3-policy"
  description = "Policy to allow access to the PyPI S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:ListBucket", "s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Effect   = "Allow"
        Resource = [aws_s3_bucket.pypi_packages.arn, "${aws_s3_bucket.pypi_packages.arn}/*"]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "pypi_s3_policy_attachment" {
  role       = aws_iam_role.pypi_server_role.name
  policy_arn = aws_iam_policy.pypi_s3_policy.arn
}