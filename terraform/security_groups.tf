resource "aws_security_group" "main-elb-security-group" {
  vpc_id = aws_vpc.main-vpc.id
  name   = "main-elb-security-group"

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main-private-subnet.cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-elb-security-group"
  }
}

resource "aws_security_group" "main-swarm-instance-security-group" {
  vpc_id = aws_vpc.main-vpc.id
  name   = "main-swarm-instance-security-group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.main-bastion-instance.private_ip}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main-public-subnet.cidr_block]
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main-public-subnet.cidr_block]
  }

  ingress {
    from_port   = 2376
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main-private-subnet.cidr_block]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main-private-subnet.cidr_block]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = [aws_subnet.main-private-subnet.cidr_block]
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = [aws_subnet.main-private-subnet.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-swarm-instance-security-group"
  }
}

resource "aws_security_group" "main-bastion-security-group" {
  vpc_id = aws_vpc.main-vpc.id
  name   = "main-bastion-security-group"

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.MY_IP}/32", aws_subnet.main-private-subnet.cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.MY_IP}/32", aws_subnet.main-private-subnet.cidr_block]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main-private-subnet.cidr_block]
  }

  tags = {
    Name = "main-bastion-security-group"
  }
}

resource "aws_security_group" "main-efs-security-group" {
  vpc_id = aws_vpc.main-vpc.id
  name   = "main-efs-security-group"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main-private-subnet.cidr_block]
  }

  egress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main-private-subnet.cidr_block]
  }

  tags = {
    Name = "main-efs-security-group"
  }
}