resource "aws_elb" "main-public-elb" {
  name            = "main-public-elb"
  subnets         = [aws_subnet.main-public-subnet.id]
  security_groups = [aws_security_group.main-elb-security-group.id]

  depends_on = [
    aws_acm_certificate.swarm-certificate
  ]

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = aws_acm_certificate.swarm-certificate.id
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:80"
    interval            = 60
  }

  cross_zone_load_balancing = false
  connection_draining       = false
  tags = {
    Name = "main-public-elb"
  }
}