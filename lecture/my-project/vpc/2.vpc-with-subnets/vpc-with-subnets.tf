provider "aws" {
  region = "ap-northeast-2"
}

### ===============================================
### VPC Start =====================================
resource "aws_vpc" "production_vpc_1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "production-vpc-1"
    Environment = "production"
    Type = "vpc"
    Sequency = "1"
  }
}
### VPC End ========================================
### ================================================

### ================================================
### Subnet Start ===================================
resource "aws_subnet" "production_public_subnet_1" {
  vpc_id = aws_vpc.production_vpc_1.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "production_public_subnet_1"
    Environment = "production"
    Type = "vpc"
    IsPublic = "true"
    Sequency = "1"
  }
}

resource "aws_subnet" "production_public_subnet_2" {
  vpc_id = aws_vpc.production_vpc_1.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "production_public_subnet_2"
    Environment = "production"
    Type = "vpc"
    IsPublic = "true"
    Sequency = "2"
  }
}
### Subnet End =======================================
### ==================================================