resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "main-nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main-public-subnet.id
  depends_on    = [aws_internet_gateway.main-public-gw]

  tags = {
    Name = "main-nat-gw"
  }
}

resource "aws_route_table" "main-private-route-table" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main-nat-gw.id
  }

  tags = {
    Name = "main-private-route-table"
  }
}

resource "aws_route_table_association" "main-private-route-table-assoc" {
  subnet_id      = aws_subnet.main-private-subnet.id
  route_table_id = aws_route_table.main-private-route-table.id
}