resource "aws_route53_zone" "primary" {
  name  = var.AWS_SWARM_DOMAIN
  count = var.CREATE_HOSTED_ZONE ? 1 : 0
}

data "aws_route53_zone" "primary" {
  name         = var.AWS_SWARM_DOMAIN
  private_zone = false
  depends_on = [
    aws_route53_zone.primary
  ]
}

resource "aws_route53_record" "wildcard_record_primary_hosted_zone" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "*.${var.AWS_SWARM_DOMAIN}"
  type    = "CNAME"
  ttl     = "300"
  records = [var.AWS_SWARM_DOMAIN]
}

data "aws_elb_hosted_zone_id" "main_public_elb_zone_id" {}

resource "aws_route53_record" "hosted_zone_main_elb_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.AWS_SWARM_DOMAIN
  type    = "A"

  alias {
    name                   = aws_elb.main_public_elb.dns_name
    zone_id                = data.aws_elb_hosted_zone_id.main_public_elb_zone_id.id
    evaluate_target_health = true
  }
}