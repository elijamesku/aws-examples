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