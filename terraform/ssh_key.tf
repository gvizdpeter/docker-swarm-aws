resource "tls_private_key" "swarmkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "swarmkey" {
  content         = tls_private_key.swarmkey.private_key_pem
  filename        = "${path.cwd}/${var.AWS_SWARM_SSH_PRIVATE_KEY_PATH}"
  file_permission = "600"
}

resource "local_file" "swarmkey-pub" {
  content         = tls_private_key.swarmkey.public_key_openssh
  filename        = "${path.cwd}/${var.AWS_SWARM_SSH_PUBLIC_KEY_PATH}"
  file_permission = "644"
}

resource "aws_key_pair" "swarmkey" {
  key_name   = "swarmkey"
  public_key = tls_private_key.swarmkey.public_key_openssh
}