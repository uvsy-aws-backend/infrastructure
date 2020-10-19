resource "aws_route53_zone" "compute_zone" {
  name = "compute.universy.app"

  tags = {
    terraform = true
    stage = var.stage
  }
}

resource "aws_route53_record" "compute_dns_challenge" {
  name    = aws_acm_certificate.compute_certificate.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.compute_certificate.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.compute_zone.id
  records = [aws_acm_certificate.compute_certificate.domain_validation_options[0].resource_record_value]
  ttl     = 60

  lifecycle {
    create_before_destroy = false
  }
}