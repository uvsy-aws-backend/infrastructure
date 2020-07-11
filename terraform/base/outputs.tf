# compute.universy.app zone id
resource "aws_ssm_parameter" "compute_zone_id_ssm_param" {
  name = "/all/route53/zones/compute/id"
  type = "String"
  value = aws_route53_zone.compute_zone.id

  tags = {
    terraform = true
    stage = var.stage
  }
}

# *.compute.universy.app cert ARN
resource "aws_ssm_parameter" "compute_cert_arn_ssm_param" {
  name = "/all/acm/cert/compute/arn"
  type = "String"
  value = aws_acm_certificate.compute_certificate.arn

  tags = {
    terraform = true
    stage = var.stage
  }
}


