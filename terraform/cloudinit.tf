data "template_file" "worker-init-config" {
  template = file("${path.cwd}/init/leader-init.cfg")
  vars = {
    DEVICE       = "${aws_efs_file_system.main-efs.id}:/"
    MOUNT_POINT  = var.AWS_SHARED_VOLUME_MOUNTPOINT
    LEADER_IP    = aws_instance.swarm-leader.private_ip
    WORKER_TOKEN = var.WORKER_TOKEN_FILE
  }
}

data "template_cloudinit_config" "swarm-worker-cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.worker-init-config.rendered
  }
}

data "template_file" "manager-init-config" {
  template = file("${path.cwd}/init/manager-init.cfg")
  vars = {
    DEVICE        = "${aws_efs_file_system.main-efs.id}:/"
    MOUNT_POINT   = var.AWS_SHARED_VOLUME_MOUNTPOINT
    LEADER_IP     = aws_instance.swarm-leader.private_ip
    MANAGER_TOKEN = var.MANAGER_TOKEN_FILE
  }
}

data "template_cloudinit_config" "swarm-manager-cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.manager-init-config.rendered
  }
}

data "template_file" "leader-init-config" {
  template = file("${path.cwd}/init/worker-init.cfg")
  vars = {
    DEVICE        = "${aws_efs_file_system.main-efs.id}:/"
    MOUNT_POINT   = var.AWS_SHARED_VOLUME_MOUNTPOINT
    WORKER_TOKEN  = var.WORKER_TOKEN_FILE
    MANAGER_TOKEN = var.MANAGER_TOKEN_FILE
  }
}

data "template_cloudinit_config" "swarm-leader-cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.leader-init-config.rendered
  }
}