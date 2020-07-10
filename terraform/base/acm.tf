resource "aws_acm_certificate" "compute_certificate" {
  domain_name       = "*.compute.universy.app"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "compute_certificate_validation" {
  certificate_arn         = aws_acm_certificate.compute_certificate.arn
  validation_record_fqdns = [aws_route53_record.domain_cert_validation.fqdn]
}

resource "aws_ssm_parameter" "compute_cert_arn_ssm_param" {
  name = "/all/acm/cert/compute/arn"
  type = "String"
  value = aws_acm_certificate.compute_certificate.arn

  tags = {
    terraform = true
    stage = var.stage
  }
}