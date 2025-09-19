provider "aws" {
  region = "us-east-2"
}


resource "aws_s3_bucket" "bucket" {
  bucket        = "policy-bucket"
  force_destroy = false

  tags = {
    Name        = "policy bucket"
    Environment = "dev"
  }

}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}
