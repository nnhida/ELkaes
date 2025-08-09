resource "aws_vpc" "techno_hida" {
  cidr_block       = "25.1.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "techno-hida"
  }
}

resource "aws_subnet" "techno_public_subnet_a" {
  vpc_id                  = aws_vpc.techno_hida.id
  cidr_block              = "25.1.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "techno-public-subnet-az-a"
  }
}

resource "aws_subnet" "techno_public_subnet_b" {
  vpc_id                  = aws_vpc.techno_hida.id
  cidr_block              = "25.1.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "techno-public-subnet-az-b"
  }
}

resource "aws_subnet" "techno_private_subnet_a" {
  vpc_id            = aws_vpc.techno_hida.id
  cidr_block        = "25.1.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "techno-private-subnet-az-a"
  }
}

resource "aws_subnet" "techno_private_subnet_b" {
  vpc_id            = aws_vpc.techno_hida.id
  cidr_block        = "25.1.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "techno-private-subnet-az-b"
  }
}

resource "aws_internet_gateway" "techno_gw" {
  vpc_id = aws_vpc.techno_hida.id

  tags = {
    Name = "techno-gw"
  }
}

resource "aws_eip" "techno_eip" {
  tags = {
    Name = "techno-eip"
  }
}

resource "aws_nat_gateway" "techno_nat" {
  allocation_id = aws_eip.techno_eip.id
  subnet_id     = aws_subnet.techno_public_subnet_a.id
}

resource "aws_route_table" "techno_public_rtb" {
  vpc_id = aws_vpc.techno_hida.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.techno_gw.id
  }

  tags = {
    Name = "techno-public-rtb"
  }
}

resource "aws_route_table" "techno_private_rtb" {
  vpc_id = aws_vpc.techno_hida.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.techno_nat.id
  }

  tags = {
    Name = "techno-private-rtb"
  }
}

resource "aws_route_table_association" "a_public" {
  subnet_id      = aws_subnet.techno_public_subnet_a.id
  route_table_id = aws_route_table.techno_public_rtb.id
}

resource "aws_route_table_association" "b_public" {
  subnet_id      = aws_subnet.techno_public_subnet_b.id
  route_table_id = aws_route_table.techno_public_rtb.id
}

resource "aws_route_table_association" "a_private" {
  subnet_id      = aws_subnet.techno_private_subnet_a.id
  route_table_id = aws_route_table.techno_private_rtb.id
}

resource "aws_route_table_association" "b_private" {
  subnet_id      = aws_subnet.techno_private_subnet_b.id
  route_table_id = aws_route_table.techno_private_rtb.id
}
