provider "aws" {
  region = "ap-northeast-2"
}

### ===============================================
### VPC Start =====================================
resource "aws_vpc" "production_vpc_1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "production vpc 1"
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
    Name = "production public subnet 1"
    Environment = "production"
    Type = "subnet"
    IsPublic = "true"
    Sequency = "1"
  }
}

resource "aws_subnet" "production_public_subnet_2" {
  vpc_id = aws_vpc.production_vpc_1.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "production public subnet 2"
    Environment = "production"
    Type = "subnet"
    IsPublic = "true"
    Sequency = "2"
  }
}
### Subnet End =======================================
### ==================================================

### ==================================================
### Internet Gateway Start ===========================
resource "aws_internet_gateway" "production_internet_gateway_1" {
  vpc_id = aws_vpc.production_vpc_1.id

  tags = {
    Name = "production internet gateway 1"
    Environment = "production"
    Type = "internet gateway"
    Sequency = "1"
  }
}
### Internet Gateway End =============================
### ==================================================

### ==================================================
### Route Table Start ================================
resource "aws_route_table" "production_route_table_1" {
  vpc_id = aws_vpc.production_vpc_1.id

  tags = {
    Name = "production route table 1"
    Environment = "production"
    Type = "route table"
    Sequency = "1"
  }
}
### Route Table End ===================================
### ===================================================

### ===================================================
### Route Table Association Start =====================
resource "aws_route_table_association" "production_route_table_association_1" {
  subnet_id = aws_subnet.production_public_subnet_1
  route_table_id = aws_route_table.production_route_table_1
}

resource "aws_route_table_association" "production_route_table_association_2" {
  subnet_id = aws_subnet.production_public_subnet_2
  route_table_id = aws_route_table.production_route_table_2
}
### Route Table Association End ========================
### ====================================================
