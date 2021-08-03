resource "aws_instance" "main-bastion-instance" {
  ami                    = file(var.AWS_AMI_ID_FILE)
  instance_type          = var.AWS_MANAGER_INSTANCE_TYPE
  subnet_id              = aws_subnet.main-public-subnet.id
  key_name               = aws_key_pair.swarmkey.key_name
  vpc_security_group_ids = [aws_security_group.main-bastion-security-group.id]

  depends_on = [
    aws_internet_gateway.main-public-gw
  ]

  tags = {
    Name = "main-bastion-instance"
  }
}