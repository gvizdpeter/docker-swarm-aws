resource "null_resource" "docker_objects_preparation" {
  depends_on = [
    aws_instance.swarm_leader
  ]

  connection {
    user         = var.AWS_INSTANCE_USERNAME
    private_key  = tls_private_key.swarmkey.private_key_pem
    host         = aws_instance.swarm_leader.private_ip
    bastion_host = aws_instance.main_bastion_instance.public_ip
    bastion_user = var.AWS_INSTANCE_USERNAME
    timeout      = var.CONNECTION_TIMEOUT
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /tmp/cloud-init-complete ]; do sleep 5 && echo 'Waiting for cloud init complete'; done"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "docker network create --driver overlay --attachable --subnet 10.10.0.0/16 traefik-public",
      "mkdir -m 777 -p ${var.AWS_SHARED_VOLUME_MOUNTPOINT}/traefik",
      "mkdir -m 777 -p ${var.AWS_SHARED_VOLUME_MOUNTPOINT}/portainer"
    ]
  }
}

module "docker_config_traefik_http" {
  depends_on = [
    null_resource.docker_objects_preparation
  ]

  source = "./modules/docker-object"

  connection_user         = var.AWS_INSTANCE_USERNAME
  connection_private_key  = tls_private_key.swarmkey.private_key_pem
  connection_host         = aws_instance.swarm_leader.private_ip
  connection_bastion_host = aws_instance.main_bastion_instance.public_ip
  connection_bastion_user = var.AWS_INSTANCE_USERNAME
  object_definition_file  = "${path.cwd}/swarm/traefik/http_config.yml"
  object_name             = "traefik_http_config"
  object_type             = "config"
  object_defintion_variables = {
    auth_password = var.AUTH_PASSWORD
  }
  remote_object_definition_directory = var.AWS_SHARED_VOLUME_MOUNTPOINT
}

module "docker_config_traefik" {
  depends_on = [
    null_resource.docker_objects_preparation
  ]

  source = "./modules/docker-object"

  connection_user                    = var.AWS_INSTANCE_USERNAME
  connection_private_key             = tls_private_key.swarmkey.private_key_pem
  connection_host                    = aws_instance.swarm_leader.private_ip
  connection_bastion_host            = aws_instance.main_bastion_instance.public_ip
  connection_bastion_user            = var.AWS_INSTANCE_USERNAME
  object_definition_file             = "${path.cwd}/swarm/traefik/config.yml"
  object_name                        = "traefik_config"
  object_type                        = "config"
  remote_object_definition_directory = var.AWS_SHARED_VOLUME_MOUNTPOINT
}

module "docker_stack_traefik" {
  depends_on = [
    null_resource.docker_objects_preparation,
    module.docker_config_traefik,
    module.docker_config_traefik_http
  ]

  source = "./modules/docker-object"

  connection_user         = var.AWS_INSTANCE_USERNAME
  connection_private_key  = tls_private_key.swarmkey.private_key_pem
  connection_host         = aws_instance.swarm_leader.private_ip
  connection_bastion_host = aws_instance.main_bastion_instance.public_ip
  connection_bastion_user = var.AWS_INSTANCE_USERNAME
  object_definition_file  = "${path.cwd}/swarm/traefik/docker-compose.tpl.yml"
  object_name             = "traefik"
  object_type             = "stack"
  object_defintion_variables = {
    swarm_domain             = var.AWS_SWARM_DOMAIN
    shared_volume_mountpoint = var.AWS_SHARED_VOLUME_MOUNTPOINT
    traefik_config           = module.docker_config_traefik.object_name
    traefik_http_config      = module.docker_config_traefik_http.object_name
  }
  remote_object_definition_directory = var.AWS_SHARED_VOLUME_MOUNTPOINT
}

module "docker_stack_portainer" {
  depends_on = [
    null_resource.docker_objects_preparation,
    module.docker_stack_traefik
  ]

  source = "./modules/docker-object"

  connection_user         = var.AWS_INSTANCE_USERNAME
  connection_private_key  = tls_private_key.swarmkey.private_key_pem
  connection_host         = aws_instance.swarm_leader.private_ip
  connection_bastion_host = aws_instance.main_bastion_instance.public_ip
  connection_bastion_user = var.AWS_INSTANCE_USERNAME
  object_definition_file  = "${path.cwd}/swarm/portainer/docker-compose.tpl.yml"
  object_name             = "portainer"
  object_type             = "stack"
  object_defintion_variables = {
    swarm_domain             = var.AWS_SWARM_DOMAIN
    shared_volume_mountpoint = var.AWS_SHARED_VOLUME_MOUNTPOINT
    auth_password            = replace(var.AUTH_PASSWORD, "$", "$$")
  }
  remote_object_definition_directory = var.AWS_SHARED_VOLUME_MOUNTPOINT
}
