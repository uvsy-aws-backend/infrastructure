resource "aws_s3_bucket" "serverless_deploy_bucket" {
  bucket = "${local.stage}.${var.region}.universy.serverless.deploys"
  acl    = "private"

  tags = {
    terraform = true
  }
}