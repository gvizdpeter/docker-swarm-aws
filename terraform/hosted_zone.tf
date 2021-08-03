resource "aws_route53_zone" "primary" {
  name = var.AWS_SWARM_DOMAIN
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

data "aws_elb_hosted_zone_id" "main-public-elb-zone-id" {}

resource "aws_route53_record" "hosted-zone-main-elb-record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.AWS_SWARM_DOMAIN
  type    = "A"

  alias {
    name                   = aws_elb.main-public-elb.dns_name
    zone_id                = data.aws_elb_hosted_zone_id.main-public-elb-zone-id.id
    evaluate_target_health = true
  }
}