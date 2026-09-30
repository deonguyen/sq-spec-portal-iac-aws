# Add a bucket policy to allow CloudFront to get objects
resource "aws_s3_bucket_policy" "pypi_bucket_policy" {
  bucket = data.aws_s3_bucket.pypi_bucket.id
  policy = data.aws_iam_policy_document.cloudfront_policy_doc.json
}

data "aws_iam_policy_document" "cloudfront_policy_doc" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${data.aws_s3_bucket.pypi_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.pypi_distribution.arn]
    }
  }
}