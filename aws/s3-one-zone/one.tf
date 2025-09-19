provider "aws" {
  region = "us-east-2"
}

variable "az_name" {
  type        = string
  description = "AZ name (e.g., us-east-2a)"
  default     = "us-east-2a"
}

# Looing up the AZ ID from the AZ name
data "aws_availability_zone" "chosen" {
  name = var.az_name
}

locals {
  az_id        = data.aws_availability_zone.chosen.zone_id  
  bucket_base  = "news-bucket"                               
  bucket_name  = "${local.bucket_base}--${local.az_id}--x-s3"
}

resource "aws_s3_directory_bucket" "news" {
  bucket = local.bucket_name

  location {
    name = local.az_id               
    type = "AvailabilityZone"     
  }

  tags = {
    Name        = "Terraform bucket"
    Environment = "test"
  }

  force_destroy = true
}
