provider "aws" {
    region = "us-east-2"
}

# creating s3 bucket with object lock enabled allowing you to lock the objects within the bucket
resource "aws_s3_bucket" "storage" {
    bucket = "newest-bucket"
    object_lock_enabled = true
}

# enabling versioning for aws bucket
resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.storage.id

    versioning_configuration {
      status = "Enabled"
    } 
}