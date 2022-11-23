provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "roy-bucket" {
  bucket = "roy-s3-bucket"
  tags = {
    "Name" = "roy-s3-bucket"
  }
}