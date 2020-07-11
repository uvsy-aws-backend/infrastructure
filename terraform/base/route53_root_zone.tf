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
