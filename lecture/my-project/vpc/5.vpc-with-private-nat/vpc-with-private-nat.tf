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
    IsPublic = true
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
    IsPublic = true
  }
}

resource "aws_subnet" "production_private_subnet_1" {
  vpc_id = aws_vpc.production_vpc_1.id
  cidr_block = "10.0.101.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "production private subnet 1"
    Environment = "production"
    Type = "subnet"
    IsPublic = false
  }
}

resource "aws_subnet" "production_private_subnet_2" {
  vpc_id = aws_vpc.production_vpc_1.id
  cidr_block = "10.0.102.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "production private subnet 2"
    Environment = "production"
    Type = "subnet"
    IsPublic = false
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
  }
}
### Internet Gateway End =============================
### ==================================================

### ==================================================
### Route Table Start ================================
resource "aws_route_table" "production_public_route_table_1" {
  vpc_id = aws_vpc.production_vpc_1.id

  tags = {
    Name = "production route table 1"
    Environment = "production"
    Type = "route table"
  }
}

resource "aws_route_table" "production_private_route_table_1" {
  vpc_id = aws_vpc.production_vpc_1.id

  tags = {
    Name = "production private route table 1"
    Environment = "production"
    Type = "route table"
  }
}

resource "aws_route_table" "production_private_route_table_2" {
  vpc_id = aws_vpc.production_vpc_1.id

  tags = {
    Name = "production private route table 2"
    Environment = "production"
    Type = "route table"
  }
}
### Route Table End ===================================
### ===================================================

### ===================================================
### Route Table Association Start =====================
resource "aws_route_table_association" "production_public_route_table_association_1" {
  subnet_id = aws_subnet.production_public_subnet_1.id
  route_table_id = aws_route_table.production_public_route_table_1.id
}

resource "aws_route_table_association" "production_public_route_table_association_2" {
  subnet_id = aws_subnet.production_public_subnet_2.id
  route_table_id = aws_route_table.production_public_route_table_1.id
}

resource "aws_route_table_association" "production_private_route_table_association_1" {
  subnet_id = aws_subnet.production_private_subnet_1.id
  route_table_id = aws_route_table.production_private_route_table_1.id
}

resource "aws_route_table_association" "production_private_route_table_association_2" {
  subnet_id = aws_subnet.production_private_subnet_2.id
  route_table_id = aws_route_table.production_private_route_table_2.id
}
### Route Table Association End ========================
### ====================================================

### ====================================================
### Mapping Route Table & Internet Gateway Start =======
resource "aws_route" "production_public_internet_gateway_ipv4_1" {
  route_table_id = aws_route_table.production_public_route_table_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.production_internet_gateway_1.id
}

resource "aws_route" "production_public_internet_gateway_ipv6_1" {
  route_table_id = aws_route_table.production_public_route_table_1.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id = aws_internet_gateway.production_internet_gateway_1.id
}
### Mapping Route Table & Internet Gateway End =========
### ====================================================

### ====================================================
### Mapping Route Table & NAT Gateway Start ============
resource "aws_route" "production_private_nat_1" {
  route_table_id = aws_route_table.production_private_route_table_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.production_nat_gateway_1.id
}

resource "aws_route" "production_private_nat_2" {
  route_table_id = aws_route_table.production_private_route_table_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.production_nat_gateway_2.id
}
### Mapping Route Table & NAT Gateway End ==============
### ====================================================

### ====================================================
### EIP Start ==========================================
resource "aws_eip" "production_eip_1" {
  vpc = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "production_eip_2" {
  vpc = true
  
  lifecycle {
    create_before_destroy = true
  }
}
### EIP End =============================================
### =====================================================

### =====================================================
### NAT Gateway Start ===================================
resource "aws_nat_gateway" "production_nat_gateway_1" {
  allocation_id = aws_eip.production_eip_1.id

  subnet_id = aws_subnet.production_private_subnet_1.id

  tags = {
    Name = "production nat gateway 1"
    Environment = "production"
    Type = "nat gateway"
  }
}

resource "aws_nat_gateway" "production_nat_gateway_2" {
  allocation_id = aws_eip.production_eip_2.id

  subnet_id = aws_subnet.production_private_subnet_2.id

  tags = {
    Name = "production nat gateway 2"
    Environment = "production"
    Type = "nat gateway"
  }
}
### NAT Gateway End =====================================
### =====================================================