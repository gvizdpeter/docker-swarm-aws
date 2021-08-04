data "template_file" "traefik_stack_file_tpl" {
  template = file("${path.cwd}/swarm/traefik-tpl.yml")
  vars = {
    swarm_domain             = var.AWS_SWARM_DOMAIN
    shared_volume_mountpoint = var.AWS_SHARED_VOLUME_MOUNTPOINT
  }
}

data "template_file" "portainer_stack_file_tpl" {
  template = file("${path.cwd}/swarm/portainer-tpl.yml")
  vars = {
    swarm_domain             = var.AWS_SWARM_DOMAIN
    shared_volume_mountpoint = var.AWS_SHARED_VOLUME_MOUNTPOINT
    portainer_admin_password = var.PORTAINER_ADMIN_PASSWORD
  }
}

resource "local_file" "traefik_stack_file" {
  content  = data.template_file.traefik_stack_file_tpl.rendered
  filename = "${path.cwd}/${var.TRAEFIK_FILE}"
}

resource "local_file" "portainer_stack_file" {
  content  = data.template_file.portainer_stack_file_tpl.rendered
  filename = "${path.cwd}/${var.PORTAINER_FILE}"
}