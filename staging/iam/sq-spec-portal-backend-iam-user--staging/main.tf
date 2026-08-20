resource "aws_iam_user" "user" {
  name = var.iam_user_name
  path = "/system/"

  tags = {
    Name = var.iam_user_name
  }
}

resource "aws_iam_access_key" "user_key" {
  user = aws_iam_user.user.name
}