provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zone" "chosen" {
  name = var.az_name

}

locals {
  az_id = data.aws_availability_zone.chosen.zone_id
}

resource "aws_s3_directory_bucket" "news" {
  bucket = "news-bucket"
  location {
    name = local.az_id
  }
  tags = {
    Name        = "Terraform bucket"
    Environment = "test"
  }

  force_destroy = true
}

variable "az_name" {
  type        = string
  description = "AZ name"
  default     = "us-east-2a"
}
