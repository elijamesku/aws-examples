# sd 10:24
# 09/10

provider "aws" {
  region = "us-east-2"
}

#s3 bucket
resource "aws_s3_bucket" "tf_state" {
  bucket        = "ss233-bucket"
  force_destroy = false

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "test"
  }
}

resource "aws_s3_bucket_cors_configuration" "tf_state"{
  
  bucket = aws_s3_bucket.tf_state.id

   cors_rule {
    id = "CORSRule1"
    allowed_methods = ["GET", "PUT"]
    allowed_origins = ["*"]
    allowed_headers = ["*"]
    expose_headers = ["ETag"]
    max_age_seconds = 3000
  }
  
}

resource "aws_s3_object" "s3_object" {
  bucket = resource.aws_s3_bucket.tf_state.id
  key    = "newfile.txt"
  source = "newfile.txt"
  etag = filemd5("newfile.txt")


}

#bucket versioning
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

#encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
