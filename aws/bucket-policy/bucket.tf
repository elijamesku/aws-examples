provider "aws" {
  region = "us-east-2"
}

# creating the bucket
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

# creating bucket policy
resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

