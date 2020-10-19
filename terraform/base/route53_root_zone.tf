resource "aws_route53_zone" "root_zone" {
  name = "universy.app"

  tags = {
    terraform = true
    stage = var.stage
  }
}

resource "aws_route53_record" "compute_subdomain_record" {
  zone_id = aws_route53_zone.root_zone.zone_id
  name = "compute.universy.app"
  type = "NS"
  ttl = "300"
  records = aws_route53_zone.compute_zone.name_servers
}

resource "aws_route53_record" "root_google_record" {
  zone_id = aws_route53_zone.root_zone.zone_id
  name = "universy.app"
  type = "TXT"
  ttl = "60"
  records = ["insert_google_challenge_here"]
}


resource "aws_route53_record" "root_dns_challenge" {
  name    = aws_acm_certificate.root_certificate.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.root_certificate.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.root_zone.id
  records = [aws_acm_certificate.root_certificate.domain_validation_options[0].resource_record_value]
  ttl     = 60

  lifecycle {
    create_before_destroy = false
  }
}
