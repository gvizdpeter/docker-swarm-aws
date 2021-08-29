data "template_file" "worker_init_config" {
  template = file("${path.cwd}/init/worker-init.cfg")
  vars = {
    DEVICE       = "${aws_efs_file_system.main_efs.id}:/"
    MOUNT_POINT  = var.AWS_SHARED_VOLUME_MOUNTPOINT
    LEADER_IP    = aws_instance.swarm_leader.private_ip
    WORKER_TOKEN = var.WORKER_TOKEN_FILE
  }
}

data "template_cloudinit_config" "swarm_worker_cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.worker_init_config.rendered
  }
}

data "template_file" "manager_init_config" {
  template = file("${path.cwd}/init/manager-init.cfg")
  vars = {
    DEVICE        = "${aws_efs_file_system.main_efs.id}:/"
    MOUNT_POINT   = var.AWS_SHARED_VOLUME_MOUNTPOINT
    LEADER_IP     = aws_instance.swarm_leader.private_ip
    MANAGER_TOKEN = var.MANAGER_TOKEN_FILE
  }
}

data "template_cloudinit_config" "swarm_manager_cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.manager_init_config.rendered
  }
}

data "template_file" "leader_init_config" {
  template = file("${path.cwd}/init/leader-init.cfg")
  vars = {
    DEVICE        = "${aws_efs_file_system.main_efs.id}:/"
    MOUNT_POINT   = var.AWS_SHARED_VOLUME_MOUNTPOINT
    WORKER_TOKEN  = var.WORKER_TOKEN_FILE
    MANAGER_TOKEN = var.MANAGER_TOKEN_FILE
  }
}

data "template_cloudinit_config" "swarm_leader_cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.leader_init_config.rendered
  }
}