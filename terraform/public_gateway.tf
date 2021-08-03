resource "aws_internet_gateway" "main-public-gw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-public-gw"
  }
}

resource "aws_route_table" "main-public-route-table" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-public-gw.id
  }

  tags = {
    Name = "main-public-route-table"
  }
}

resource "aws_route_table_association" "main-public-route-table-assoc" {
  subnet_id      = aws_subnet.main-public-subnet.id
  route_table_id = aws_route_table.main-public-route-table.id
}