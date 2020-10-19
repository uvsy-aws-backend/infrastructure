data "aws_acm_certificate" "root_certificate" {
  domain   = "*.universy.app"
  statuses = ["ISSUED"]
  provider = aws.us
}

module "cdn" {
  acm_certificate_arn = data.aws_acm_certificate.root_certificate.arn
  source = "git::https://github.com/cloudposse/terraform-aws-cloudfront-s3-cdn.git?ref=tags/0.26.0"
  namespace = "universy"
  stage = local.stage
  name = "universy"
  website_enabled = true
  max_ttl = 300
  aliases = [
    "${local.stage}.universy.app",
  ]
  parent_zone_name = "universy.app"
}
