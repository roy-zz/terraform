provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform-roy-vpc-prod"
  }
}