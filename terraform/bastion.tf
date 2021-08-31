resource "aws_instance" "main_bastion_instance" {
  ami                    = var.DEFAULT_AMI_ID
  instance_type          = var.AWS_SWARM_INSTANCE_TYPE
  subnet_id              = module.main_vpc.public_subnets[0]
  key_name               = aws_key_pair.swarmkey.key_name
  vpc_security_group_ids = [aws_security_group.main_bastion_security_group.id]

  depends_on = [
    module.main_vpc
  ]

  tags = {
    Name = "main-bastion-instance"
  }
}

resource "local_file" "bastion_public_ip" {
  content  = aws_instance.main_bastion_instance.public_ip
  filename = "${path.cwd}/${var.BASTION_IP_FILE}"
}