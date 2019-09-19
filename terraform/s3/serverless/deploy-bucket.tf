
resource "aws_s3_bucket" "serverless_deploy_bucket" {
  bucket = "universy.serverless.deploys"
  acl    = "private"
}