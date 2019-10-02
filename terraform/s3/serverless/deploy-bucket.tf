variable "stage" {}

variable "region" {}

resource "aws_s3_bucket" "serverless_deploy_bucket" {
  bucket = "${var.stage}.${var.region}.universy.serverless.deploys"
  acl    = "private"
}