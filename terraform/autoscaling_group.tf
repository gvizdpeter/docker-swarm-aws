resource "aws_launch_configuration" "swarm_worker_launch_config" {
  name_prefix     = "swarm-worker-"
  image_id        = data.local_file.packer_ami_file.content
  instance_type   = var.AWS_SWARM_INSTANCE_TYPE
  key_name        = aws_key_pair.swarmkey.key_name
  security_groups = [aws_security_group.main_swarm_instance_security_group.id]
  user_data       = data.template_cloudinit_config.swarm_worker_cloudinit.rendered
  root_block_device {
    volume_size = 8
  }
}

resource "aws_autoscaling_group" "swarm_worker_autoscaling" {
  name                      = "swarm-worker-autoscaling"
  vpc_zone_identifier       = [aws_subnet.main_private_subnet.id]
  launch_configuration      = aws_launch_configuration.swarm_worker_launch_config.name
  min_size                  = var.AWS_MIN_WORKER_COUNT
  max_size                  = var.AWS_MAX_WORKER_COUNT
  health_check_grace_period = 30
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "swarm-worker"
    propagate_at_launch = true
  }
}