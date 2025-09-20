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

 1. Set your Homebrew directory
export HOMEBREW_PREFIX="$HOME/homebrew"


(You can also add this to your .zshrc later.)

 2. Clone Homebrew into your home folder
git clone https://github.com/Homebrew/brew "$HOMEBREW_PREFIX"


This clones the actual Homebrew core scripts — same as the installer would do.

 3. Add Homebrew to your PATH

Add this to your ~/.zshrc:

echo 'export PATH="$HOME/homebrew/bin:$PATH"' >> ~/.zshrc
echo 'export HOMEBREW_NO_ANALYTICS=1' >> ~/.zshrc
source ~/.zshrc

 4. Verify it's working
brew --version


You should see something like:

Homebrew 4.x.x

5. Try installing a package
