resource "aws_launch_configuration" "swarm-worker-launch-config" {
  name_prefix     = "swarm-worker-"
  image_id        = file(var.AWS_AMI_ID_FILE)
  instance_type   = var.AWS_WORKER_INSTANCE_TYPE
  key_name        = aws_key_pair.swarmkey.key_name
  security_groups = [aws_security_group.main-swarm-instance-security-group.id]
  user_data       = data.template_cloudinit_config.swarm-worker-cloudinit.rendered
  root_block_device {
    volume_size = 8
  }
}

resource "aws_autoscaling_group" "swarm-worker-autoscaling" {
  name                      = "swarm-worker-autoscaling"
  vpc_zone_identifier       = [aws_subnet.main-private-subnet.id]
  launch_configuration      = aws_launch_configuration.swarm-worker-launch-config.name
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