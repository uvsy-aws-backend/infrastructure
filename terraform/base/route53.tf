resource "aws_route53_zone" "main_zone" {
  name = "universy.app"

  tags = {
    terraform = true
    stage = var.stage
  }
}

resource "aws_route53_zone" "compute_zone" {
  name = "compute.universy.app"

  tags = {
    terraform = true
    stage = var.stage
  }
}

resource "aws_ssm_parameter" "compute_zone_id_ssm_param" {
  name = "/all/route53/zones/compute/id"
  type = "String"
  value = aws_route53_zone.compute_zone.id

  tags = {
    terraform = true
    stage = var.stage
  }
}

resource "aws_route53_record" "compute_set" {
  zone_id = aws_route53_zone.main_zone.zone_id
  name = "compute.universy.app"
  type = "NS"
  ttl = "300"
  records = aws_route53_zone.compute_zone.name_servers
}


resource "aws_route53_record" "domain_cert_validation" {
  name    = aws_acm_certificate.compute_certificate.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.compute_certificate.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.compute_zone.id
  records = [aws_acm_certificate.compute_certificate.domain_validation_options[0].resource_record_value]
  ttl     = 60
}