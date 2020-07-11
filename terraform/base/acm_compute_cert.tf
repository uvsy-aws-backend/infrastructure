

/*
---------- *.compute.universy.app ----------
*/

# Certificate
resource "aws_acm_certificate" "compute_certificate" {
  domain_name       = "*.compute.universy.app"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Certificate DNS validation
resource "aws_acm_certificate_validation" "compute_certificate_validation" {
  certificate_arn         = aws_acm_certificate.compute_certificate.arn
  validation_record_fqdns = [aws_route53_record.compute_dns_challenge.fqdn]
}
