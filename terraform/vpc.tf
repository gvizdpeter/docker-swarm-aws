module "main_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 3.7.0"

  name = "main-vpc"
  cidr = "192.168.0.0/16"

  azs             = [var.AWS_DEFAULT_AZ]
  public_subnets  = ["192.168.1.0/24"]
  private_subnets = ["192.168.2.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
    Name = "main-vpc"
  }
}