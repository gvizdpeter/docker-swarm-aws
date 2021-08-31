locals {
  connection = {
    user         = var.AWS_INSTANCE_USERNAME
    private_key  = tls_private_key.swarmkey.private_key_pem
    host         = aws_instance.swarm_leader.private_ip
    bastion_host = aws_instance.main_bastion_instance.public_ip
    bastion_user = var.AWS_INSTANCE_USERNAME
    timeout      = var.CONNECTION_TIMEOUT
  }
}