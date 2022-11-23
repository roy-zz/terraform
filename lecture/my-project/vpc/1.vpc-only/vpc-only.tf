provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"

  tags = {
    name = "terraform-roy-vpc-prod"
  }
}