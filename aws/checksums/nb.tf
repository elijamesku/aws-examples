## new s3 bucket 

provider "aws" {
  region = "us-east-2"
}

#s3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = "new-ss233-bucket"
  force_destroy = false

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "test"
  }
}

resource "aws_s3_object" "s3_object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "newdoc.txt"
  source = "newdoc.txt"
  #etag   = filemd5("newdoc.txt")
  source_hash = filemd5("newdoc.txt")


}

#bucket versioning
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

#encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
