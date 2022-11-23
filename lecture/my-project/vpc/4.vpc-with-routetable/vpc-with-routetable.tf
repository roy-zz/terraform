provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "terraform-roy-vpc-prod"
  }
}

resource "aws_subnet" "first_subnet" {
  vpc_id = aws_vpc.prod.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    "Name" = "terraform-roy-subnet-1"
  }
}

resource "aws_subnet" "second_subnet" {
  vpc_id = aws_vpc.prod.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    "Name" = "terraform-roy-subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod.id

  tags = {
    "Name" = "terraform-roy-igw-1"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.prod.id

  tags = {
    "Name" = "terraform-roy-rt-1"
  }
}

resource "aws_route_table_association" "route_table_association_1" {
  subnet_id = aws_subnet.first_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association_2" {
  subnet_id = aws_subnet.second_subnet.id
  route_table_id = aws_route_table.route_table.id
}
