resource "aws_internet_gateway" "main_public_gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-public-gw"
  }
}

resource "aws_route_table" "main_public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_public_gw.id
  }

  tags = {
    Name = "main-public-route-table"
  }
}

resource "aws_route_table_association" "main_public_route_table_assoc" {
  subnet_id      = aws_subnet.main_public_subnet.id
  route_table_id = aws_route_table.main_public_route_table.id
}