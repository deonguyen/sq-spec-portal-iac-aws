# Create an IAM user for uploading packages to the S3 bucket.
resource "aws_iam_user" "pypi_uploader" {
  name = var.iam_user_name
  path = "/system/"
}

# Generate access keys for the IAM user.
# These keys will be used to configure your local environment for publishing.
resource "aws_iam_access_key" "pypi_uploader_keys" {
  user = aws_iam_user.pypi_uploader.name
}

# Define an IAM policy that grants the necessary permissions for s3pypi.
data "aws_iam_policy_document" "pypi_policy_doc" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      data.aws_s3_bucket.pypi_bucket.arn,
      "${data.aws_s3_bucket.pypi_bucket.arn}/*",
    ]
  }
}

# Attach the policy to the IAM user.
resource "aws_iam_user_policy" "pypi_policy_attachment" {
  name   = "s3pypi-policy"
  user   = aws_iam_user.pypi_uploader.name
  policy = data.aws_iam_policy_document.pypi_policy_doc.json
}