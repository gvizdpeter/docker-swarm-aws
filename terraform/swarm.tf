resource "aws_instance" "swarm-leader" {
  ami                    = file("${path.cwd}/${var.AWS_AMI_ID_FILE}")
  instance_type          = var.AWS_MANAGER_INSTANCE_TYPE
  subnet_id              = aws_subnet.main-private-subnet.id
  key_name               = aws_key_pair.swarmkey.key_name
  vpc_security_group_ids = [aws_security_group.main-swarm-instance-security-group.id]
  user_data              = data.template_cloudinit_config.swarm-leader-cloudinit.rendered
  root_block_device {
    volume_size = 8
  }

  depends_on = [
    aws_efs_mount_target.main-efs-mount-target
  ]

  tags = {
    Name = "swarm-leader"
  }
}

resource "aws_instance" "swarm-manager" {
  count                  = var.AWS_MANAGER_COUNT - 1
  ami                    = file("${path.cwd}/${var.AWS_AMI_ID_FILE}")
  instance_type          = var.AWS_MANAGER_INSTANCE_TYPE
  subnet_id              = aws_subnet.main-private-subnet.id
  key_name               = aws_key_pair.swarmkey.key_name
  vpc_security_group_ids = [aws_security_group.main-swarm-instance-security-group.id]
  user_data              = data.template_cloudinit_config.swarm-manager-cloudinit.rendered
  root_block_device {
    volume_size = 8
  }  

  tags = {
    Name = "swarm-manager-${count.index}"
  }
}

resource "null_resource" "stack-deploy" {
  depends_on = [
    aws_instance.swarm-manager
  ]

  provisioner "file" {
    connection {
      user         = var.AWS_INSTANCE_USERNAME
      private_key  = tls_private_key.swarmkey.private_key_pem
      host         = aws_instance.swarm-leader.private_ip
      bastion_host = aws_instance.main-bastion-instance.public_ip
      bastion_user = var.AWS_INSTANCE_USERNAME
    }

    source      = var.TRAEFIK_FILE
    destination = "${var.AWS_SHARED_VOLUME_MOUNTPOINT}/${var.TRAEFIK_FILE}"
  }

  provisioner "file" {
    connection {
      user         = var.AWS_INSTANCE_USERNAME
      private_key  = tls_private_key.swarmkey.private_key_pem
      host         = aws_instance.swarm-leader.private_ip
      bastion_host = aws_instance.main-bastion-instance.public_ip
      bastion_user = var.AWS_INSTANCE_USERNAME
    }

    source      = var.PORTAINER_FILE
    destination = "${var.AWS_SHARED_VOLUME_MOUNTPOINT}/${var.PORTAINER_FILE}"
  }

  provisioner "remote-exec" {
    connection {
      user         = var.AWS_INSTANCE_USERNAME
      private_key  = tls_private_key.swarmkey.private_key_pem
      host         = aws_instance.swarm-leader.private_ip
      bastion_host = aws_instance.main-bastion-instance.public_ip
      bastion_user = var.AWS_INSTANCE_USERNAME
    }

    inline = [
      "docker stack deploy -c ${var.AWS_SHARED_VOLUME_MOUNTPOINT}/${var.TRAEFIK_FILE} traefik",
      "docker stack deploy -c ${var.AWS_SHARED_VOLUME_MOUNTPOINT}/${var.PORTAINER_FILE} portainer",
      "docker service ls"
    ]
  }
}

resource "aws_elb_attachment" "main-swarm-leader-elb-attachment" {
  elb      = aws_elb.main-public-elb.id
  instance = aws_instance.swarm-leader.id
}

resource "aws_elb_attachment" "main-swarm-manager-elb-attachment" {
  count    = length(aws_instance.swarm-manager)
  elb      = aws_elb.main-public-elb.id
  instance = aws_instance.swarm-manager[count.index].id
}

resource "local_file" "bastion-public-ip" {
  content  = aws_instance.main-bastion-instance.public_ip
  filename = "${path.cwd}/${var.BASTION_IP_FILE}"
}

resource "local_file" "swarm-leader-ip" {
  content  = aws_instance.swarm-leader.private_ip
  filename = "${path.cwd}/${var.SWARM_LEADER_IP_FILE}"
}