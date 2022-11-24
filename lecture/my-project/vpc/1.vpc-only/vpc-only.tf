provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "production_vpc_1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "production-vpc-1"
    Environment = "production"
    Type = "vpc"
    Sequency = "1"
  }
}