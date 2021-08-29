resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "main_nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main_public_subnet.id
  depends_on    = [aws_internet_gateway.main_public_gw]

  tags = {
    Name = "main-nat-gw"
  }
}

resource "aws_route_table" "main_private_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_nat_gw.id
  }

  tags = {
    Name = "main-private-route-table"
  }
}

resource "aws_route_table_association" "main_private_route_table_assoc" {
  subnet_id      = aws_subnet.main_private_subnet.id
  route_table_id = aws_route_table.main_private_route_table.id
}