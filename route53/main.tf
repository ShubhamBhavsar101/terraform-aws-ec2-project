variable "domain_name" {}
variable "dns_name" {}
variable "domain_validation_options" {}
variable "zone_id" {}


data "aws_route53_zone" "shubhambuilds" {
  name = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "apache" {
  zone_id = data.aws_route53_zone.shubhambuilds.zone_id
  name    = "apache.shubhambuilds.space"
  type    = "A"

  alias {
    name                   = var.dns_name
    zone_id                = var.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "apache_cname_validation" {
  for_each = {
    for dvo in var.domain_validation_options : dvo.domain_name => dvo
  }
  zone_id = data.aws_route53_zone.shubhambuilds.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl = 60
}