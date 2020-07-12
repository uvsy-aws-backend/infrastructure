# Certificate
resource "aws_acm_certificate" "root_certificate" {
  domain_name       = "*.universy.app"
  validation_method = "DNS"

  provider = aws.us

  lifecycle {
    create_before_destroy = true
  }
}

# Certificate DNS validation
resource "aws_acm_certificate_validation" "root_certificate_validation" {
  provider = aws.us
  certificate_arn         = aws_acm_certificate.root_certificate.arn
  validation_record_fqdns = [aws_route53_record.root_dns_challenge.fqdn]
}
