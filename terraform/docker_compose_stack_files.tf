data "template_file" "traefik_stack_file" {
  template = file("${path.cwd}/swarm/traefik/docker-compose.tpl.yml")
  vars = {
    swarm_domain             = var.AWS_SWARM_DOMAIN
    shared_volume_mountpoint = var.AWS_SHARED_VOLUME_MOUNTPOINT
  }
}

data "template_file" "portainer_stack_file" {
  template = file("${path.cwd}/swarm/portainer/docker-compose.tpl.yml")
  vars = {
    swarm_domain             = var.AWS_SWARM_DOMAIN
    shared_volume_mountpoint = var.AWS_SHARED_VOLUME_MOUNTPOINT
    portainer_admin_password = var.AUTH_PASSWORD
  }
}