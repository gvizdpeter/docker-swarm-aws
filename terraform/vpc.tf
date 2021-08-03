resource "aws_vpc" "main-vpc" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main-public-subnet" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.AWS_DEFAULT_AZ

  tags = {
    Name = "main-public-subnet"
  }
}

resource "aws_subnet" "main-private-subnet" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = var.AWS_DEFAULT_AZ

  tags = {
    Name = "main-private-subnet"
  }
}