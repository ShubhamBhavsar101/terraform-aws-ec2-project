resource "aws_acm_certificate" "apache_certificate" {
  domain_name       = "apache.shubhambuilds.space"
  validation_method = "DNS"

  tags = {
    Environment = "Development"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "apache_domain_validation_options" {
  value = aws_acm_certificate.apache_certificate.domain_validation_options
}

output "apache_acm_certificate_arn" {
    value = aws_acm_certificate.apache_certificate.arn
}