resource "tls_private_key" "swarmkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_swarmkey" {
  content         = tls_private_key.swarmkey.private_key_pem
  filename        = "/root/.ssh/swarmkey"
  file_permission = "600"
}

resource "local_file" "public_swarmkey" {
  content         = tls_private_key.swarmkey.public_key_openssh
  filename        = "/root/.ssh/swarmkey.pub"
  file_permission = "644"
}

resource "aws_key_pair" "swarmkey" {
  key_name   = "swarmkey"
  public_key = tls_private_key.swarmkey.public_key_openssh
}

data "template_file" "ssh_config" {
  template = file("${path.cwd}/ssh/ssh_config.tpl")
  vars = {
    bastion_ip              = aws_instance.main_bastion_instance.public_ip
    aws_instance_username   = var.AWS_INSTANCE_USERNAME
    ssh_swarm_key           = local_file.private_swarmkey.filename
    swarm_leader_ip         = aws_instance.swarm_leader.private_ip
    private_subnet_wildcard = replace(module.main_vpc.private_subnets_cidr_blocks[0], "/0\\/24$/", "*")
  }
}

resource "local_file" "ssh_config" {
  content         = data.template_file.ssh_config.rendered
  filename        = "/root/.ssh/config"
  file_permission = "600"
}