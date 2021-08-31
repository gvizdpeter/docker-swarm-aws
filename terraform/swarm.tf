resource "aws_instance" "swarm_leader" {
  ami                    = data.local_file.packer_ami_file.content
  instance_type          = var.AWS_SWARM_INSTANCE_TYPE
  subnet_id              = module.main_vpc.private_subnets[0]
  key_name               = aws_key_pair.swarmkey.key_name
  vpc_security_group_ids = [aws_security_group.main_swarm_instance_security_group.id]
  user_data              = data.template_cloudinit_config.swarm_leader_cloudinit.rendered
  root_block_device {
    volume_size = 8
  }

  depends_on = [
    null_resource.packer_instance,
    aws_efs_mount_target.main_efs_mount_target
  ]

  tags = {
    Name = "swarm-leader"
  }
}

resource "aws_instance" "swarm_manager" {
  count                  = var.AWS_MANAGER_COUNT - 1
  ami                    = data.local_file.packer_ami_file.content
  instance_type          = var.AWS_SWARM_INSTANCE_TYPE
  subnet_id              = module.main_vpc.private_subnets[0]
  key_name               = aws_key_pair.swarmkey.key_name
  vpc_security_group_ids = [aws_security_group.main_swarm_instance_security_group.id]
  user_data              = data.template_cloudinit_config.swarm_manager_cloudinit.rendered
  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "swarm-manager-${count.index}"
  }
}

resource "aws_elb_attachment" "main_swarm_leader_elb_attachment" {
  elb      = aws_elb.main_public_elb.id
  instance = aws_instance.swarm_leader.id
}

resource "aws_elb_attachment" "main_swarm_manager_elb_attachment" {
  count    = length(aws_instance.swarm_manager)
  elb      = aws_elb.main_public_elb.id
  instance = aws_instance.swarm_manager[count.index].id
}

resource "local_file" "swarm_leader_ip" {
  content  = aws_instance.swarm_leader.private_ip
  filename = "${path.cwd}/${var.SWARM_LEADER_IP_FILE}"
}