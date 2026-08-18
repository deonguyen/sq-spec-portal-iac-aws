data "aws_s3_bucket" "log_bucket" {
  bucket = var.bucket_name
}

data "aws_caller_identity" "current" {}

data "aws_elb_service_account" "this" {}

data "aws_iam_policy_document" "elb_log_delivery" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.this.arn]
    }
    actions   = ["s3:PutObject"]
    resources = ["${data.aws_s3_bucket.log_bucket.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [data.aws_s3_bucket.log_bucket.arn]
  }
}

resource "aws_s3_bucket_policy" "elb_log_delivery" {
  bucket = data.aws_s3_bucket.log_bucket.id
  policy = data.aws_iam_policy_document.elb_log_delivery.json
}