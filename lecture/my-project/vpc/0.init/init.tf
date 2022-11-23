terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.40.0"
    }
  }
}

resource "aws_s3_bucket" "tfstate" {
  bucket  = "terraform-roy-apne2-tfstate"
}

resource "aws_s3_bucket_versioning" "versioning_tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_State_lock" {
  name = "terraform-roy-lock"
  hash_key = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}