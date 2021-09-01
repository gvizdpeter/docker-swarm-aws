resource "null_resource" "docker_objects_preparation" {
  depends_on = [
    aws_instance.swarm_leader
  ]

  triggers = {
    script = filemd5("${path.cwd}/scripts/docker_objects_preparation.sh")
  }

  connection {
    user         = local.connection.user
    private_key  = local.connection.private_key
    host         = local.connection.host
    bastion_host = local.connection.bastion_host
    bastion_user = local.connection.bastion_user
    timeout      = local.connection.timeout
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /tmp/cloud-init-complete ]; do sleep 5 && echo 'Waiting for cloud init complete'; done"
    ]
  }

  provisioner "file" {
    source      = "${path.cwd}/scripts/docker_objects_preparation.sh"
    destination = "/tmp/docker_objects_preparation.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/docker_objects_preparation.sh",
      "/tmp/docker_objects_preparation.sh ${var.AWS_SHARED_VOLUME_MOUNTPOINT}",
    ]
  }
}

module "docker_config_traefik_http" {
  depends_on = [
    null_resource.docker_objects_preparation
  ]

  source = "./modules/docker-object"

  connection_object      = local.connection
  object_definition_file = "${path.cwd}/swarm/traefik/http_config.yml"
  object_name            = "traefik_http_config"
  object_type            = "config"
  object_defintion_variables = {
    auth_password = var.AUTH_PASSWORD
  }
}

module "docker_config_traefik" {
  depends_on = [
    null_resource.docker_objects_preparation
  ]

  source = "./modules/docker-object"

  connection_object      = local.connection
  object_definition_file = "${path.cwd}/swarm/traefik/config.yml"
  object_name            = "traefik_config"
  object_type            = "config"
}

module "docker_stack_traefik" {
  depends_on = [
    null_resource.docker_objects_preparation,
    module.docker_config_traefik,
    module.docker_config_traefik_http
  ]

  source = "./modules/docker-object"

  connection_object = local.connection

  object_definition_file = "${path.cwd}/swarm/traefik/docker-compose.tpl.yml"
  object_name            = "traefik"
  object_type            = "stack"
  object_defintion_variables = {
    swarm_domain             = var.AWS_SWARM_DOMAIN
    shared_volume_mountpoint = var.AWS_SHARED_VOLUME_MOUNTPOINT
    traefik_config           = module.docker_config_traefik.object_name
    traefik_http_config      = module.docker_config_traefik_http.object_name
  }
}

module "docker_stack_portainer" {
  depends_on = [
    null_resource.docker_objects_preparation,
    module.docker_stack_traefik
  ]

  source = "./modules/docker-object"

  connection_object = local.connection

  object_definition_file = "${path.cwd}/swarm/portainer/docker-compose.tpl.yml"
  object_name            = "portainer"
  object_type            = "stack"
  object_defintion_variables = {
    swarm_domain             = var.AWS_SWARM_DOMAIN
    shared_volume_mountpoint = var.AWS_SHARED_VOLUME_MOUNTPOINT
    auth_password            = replace(var.AUTH_PASSWORD, "$", "$$")
  }
}
