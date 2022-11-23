provider "aws" {
  region = "ap-northeast-2"
  version = "~> 4.40.0"
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "terraform-jupiter-apne2-tfstate"

  versioning {
    enabled = true
  }
}