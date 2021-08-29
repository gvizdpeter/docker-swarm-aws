resource "aws_security_group" "main_elb_security_group" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "main-elb-security-group"

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main_private_subnet.cidr_block]
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

resource "aws_security_group" "main_swarm_instance_security_group" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "main-swarm-instance-security-group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.main_bastion_instance.private_ip}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main_public_subnet.cidr_block]
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main_public_subnet.cidr_block]
  }

  ingress {
    from_port   = 2376
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main_private_subnet.cidr_block]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main_private_subnet.cidr_block]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = [aws_subnet.main_private_subnet.cidr_block]
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = [aws_subnet.main_private_subnet.cidr_block]
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

resource "aws_security_group" "main_bastion_security_group" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "main-bastion-security-group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main_private_subnet.cidr_block]
  }

  tags = {
    Name = "main-bastion-security-group"
  }
}

resource "aws_security_group" "main_efs_security_group" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "main-efs-security-group"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main_private_subnet.cidr_block]
  }

  egress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main_private_subnet.cidr_block]
  }

  tags = {
    Name = "main-efs-security-group"
  }
}