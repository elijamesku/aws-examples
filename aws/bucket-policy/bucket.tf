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

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

curl -LO https://github.com/cli/cli/releases/download/v2.45.0/gh_2.45.0_macOS_arm64.tar.gz
tar -xzf gh_2.45.0_macOS_arm64.tar.gz
mv gh_2.45.0_macOS_arm64/bin/gh ~/bin/
