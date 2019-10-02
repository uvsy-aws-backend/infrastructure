variable "stage" {}

resource "aws_s3_bucket" "serverless_deploy_bucket" {
  bucket = "${var.stage}.universy.serverless.deploys"
  acl    = "private"
}