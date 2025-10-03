# sd 10:24
# 09/10
# bucket with public access block, cors cofnfig, encryption, versioning with object test


# cloud provider
provider "aws" {
  region = "us-east-2"
}


# public access block turned on for private s3
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.tf_state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
  
}


# key set
resource "aws_kms_key" "s3" {
  description = "CMK for s3 bucket ss233"
  deletion_window_in_days = 30
  enable_key_rotation = true
  
}


# kms key alias
resource "aws_kms_alias" "s3" {
  name = "alias/ss223-bucket"
  target_key_id = aws_kms_key.s3.key_id
  
}


# s3 bucket
resource "aws_s3_bucket" "tf_state" {
  bucket        = "ss233-bucket"
  force_destroy = false

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "test"
  }
}



# cors configuration allowing get post put for all origins for now
resource "aws_s3_bucket_cors_configuration" "tf_state"{
   bucket = aws_s3_bucket.tf_state.id

   cors_rule {
    allowed_methods = ["GET", "POST", "PUT"]
    allowed_origins = ["*"]
    allowed_headers = ["*"]
    expose_headers = ["ETag"]
    max_age_seconds = 3000
  }

}

# adding bucket object
resource "aws_s3_object" "s3_object" {
  bucket = aws_s3_bucket.tf_state.id
  key    = "newfile.txt"
  etag   = filemd5("newfile.txt")
  server_side_encryption = "aws:kms"
  kms_key_id = aws_kms_key.s3.arn
  source = "newfile.txt"
}


# bucket versioning
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}


# encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
      kms_master_key_id = aws_kms_key.s3.arn
    }
    bucket_key_enabled = true
  }
}

## add global accelerator