variable "stage" {}

variable "region" {}

module "serverless-deploy-bucket" {
  source = "./serverless"
  stage = "${var.stage}"
  region = "${var.region}"
}