module "swarm_acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.2.0"

  domain_name = var.AWS_SWARM_DOMAIN
  zone_id     = data.aws_route53_zone.primary.zone_id

  subject_alternative_names = [
    "*.${var.AWS_SWARM_DOMAIN}"
  ]

  wait_for_validation = true

  tags = {
    Name = var.AWS_SWARM_DOMAIN
  }
}