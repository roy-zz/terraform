# Terraform with VPC

이번 장에서는 AWS의 VPC에 대해서 간략하게 살펴보고 Terraform을 사용하여 VPC를 구축하는 방법에 대해서 알아본다.

---

## VPC 란

Amazon VPC는 Amazon에서 제공하는 Private 네트워크 망(Private Virtual Cloud)이다. 핵심이 되는 구성요소로는 아래와 같은 요소들이 있다.

- **Virtual Private Cloud(VPC)**: 사용자의 AWS 계정 전용 가상 네트워크다.
- **서브넷**: VPC의 IP 주소 범위를 정한다.
- **라우팅 테이블**: 네트워크 트래픽을 전달할 위치를 결정하는 데 사용되는 라우팅이라는 규칙의 집합니다.
- **인터넷 게이트웨이**: VPC의 리소스와 인터넷 간의 통신을 활성화하기 위해 VPC에 연결하는 게이트웨이다.
- **NAT 게이트웨이:** 네트워크 주소 변환을 통해 프라이빗 서브넷에서 인터늣 또는 기타 AWS 서비스에 연결하는 게이트웨이다.
- **Secuirty Group**: 보안 그룹은 인스턴스에 대한 인바운드 및 아웃바운드 트래픽을 제어하는 가상 방화벽 역할을 하는 규칙의 집합니다.
- **VPC 엔드포인트**: 인터넷 게이트웨이, NAT 디바이스, VPN 연결 또는 AWS Direct Connect 연결을 필요로하지 않고 PrivateLink 구동 지원 AWS 서비스 및 VPC 엔드포인트 서비스에 VPC를 비공개로 연결할 수 있다. VPC의 인스턴스는 서비스의 리소스와 통신하는 데 퍼블릭 IP 주소를 필요로 하지 않는다. VPC와 기타 서비스 간의 트래픽은 Amazon 네트워크를 벗어나지 않는다.

---

## VPC 생성

필자가 참고한 강의에서는 VPC 생성을 단계별로 진행하였으나, 필자는 모든 단계의 스크립트를 하나로 합쳐두고 하나씩 알아보는 방식으로 진행하도록 하겠다.

```
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
```






































### 참고

- VPC를 생성할 때는 `aws_vpc` 리소스를 사용하면 되고, 필수값으로는 `cidr_block`이 있다.














---

### 참고 자료

- [https://terraform101.inflearn.devopsart.dev/cont/vpc-intro/](https://terraform101.inflearn.devopsart.dev/cont/vpc-intro/)