resource "aws_autoscaling_policy" "high_cpu_policy" {
  name                   = "high-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.swarm_worker_autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "120"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "high-cpu-alarm"
  alarm_description   = "high-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = var.HIGH_CPU_THRESH

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.swarm_worker_autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.high_cpu_policy.arn]
}

resource "aws_autoscaling_policy" "low_cpu_policy" {
  name                   = "low-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.swarm_worker_autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "120"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
  alarm_name          = "low-cpu-alarm"
  alarm_description   = "low-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = var.LOW_CPU_THRESH

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.swarm_worker_autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.low_cpu_policy.arn]
}