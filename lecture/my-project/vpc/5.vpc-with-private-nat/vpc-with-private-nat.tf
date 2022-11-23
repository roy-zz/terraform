provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "prod-vpc"
  }
}

resource "aws_subnet" "prod_subnet_1" {
  vpc_id = aws_vpc.prod_vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    "Name" = "prod-subnet-1"
  }
}

resource "aws_subnet" "prod_subnet_2" {
  vpc_id = aws_vpc.prod_vpc.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    "Name" = "prod-subnet-2"
  }
}

resource "aws_internet_gateway" "igw-1" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    "Name" = "prod-igw-1"
  }
}

resource "aws_route_table" "prod_route_table_1" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    "Name" = "prod-route-table-1"
  }
}

resource "aws_route_table_association" "prod_route_table_1_association_1" {
  subnet_id = aws_subnet.prod_subnet_1.id
  route_table_id = aws_route_table.prod_route_table_1.id
}

resource "aws_route_table_association" "prod_route_table_2_association_2" {
  subnet_id = aws_subnet.prod_subnet_2.id
  route_table_id = aws_route_table.prod_route_table_1.id
}

resource "aws_route" "prod_public_internet_gateway_ipv4_1" {
  route_table_id = aws_route_table.prod_route_table_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw-1.id
}

resource "aws_route" "prod_public_internet_gateway_ipv6_1" {
  route_table_id = aws_route_table.prod_route_table_1.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id = aws_internet_gateway.igw-1.id
}

resource "aws_subnet" "prod_private_subnet_1" {
  vpc_id = aws_vpc.prod_vpc.id
  cidr_block = "10.0.4.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    "Name" = "prod-private-subnet-1"
  }
}

resource "aws_subnet" "prod_private_subnet_2" {
  vpc_id = aws_vpc.prod_vpc.id
  cidr_block = "10.0.5.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    "Name" = "prod-private-subnet-2"
  }
}

resource "aws_eip" "prod_nat_1" {
  vpc = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "prod_nat_2" {
  vpc = true
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "prod_nat_gateway_1" {
  allocation_id = aws_eip.prod_nat_1.id

  subnet_id = aws_subnet.prod_subnet_1.id

  tags = {
    Name = "prod-nat-gateway-1"
  }
}

resource "aws_nat_gateway" "prod_nat_gateway_2" {
  allocation_id = aws_eip.prod_nat_2.id

  subnet_id = aws_subnet.prod_subnet_2.id

  tags = {
    Name = "prod-nat-gateway-2"
  }
}

resource "aws_route_table" "prod_private_route_table_1" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    "Name" = "prod-private-route-table-1"
  }
}

resource "aws_route_table" "prod_private_route_table_2" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    "Name" = "prod-private-route-table-2"
  }
}

resource "aws_route_table_association" "prod_private_route_table_1_association" {
  subnet_id = aws_subnet.prod_private_subnet_1.id
  route_table_id = aws_route_table.prod_private_route_table_1.id
}

resource "aws_route_table_association" "prod_private_route_table_2_association" {
  subnet_id = aws_subnet.prod_private_subnet_2.id
  route_table_id = aws_route_table.prod_private_route_table_2.id
}

resource "aws_route" "prod_private_nat_1" {
  route_table_id = aws_route_table.prod_private_route_table_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.prod_nat_gateway_1.id
}

resource "aws_route" "prod_private_nat_2" {
  route_table_id = aws_route_table.prod_private_route_table_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.prod_nat_gateway_2.id
}