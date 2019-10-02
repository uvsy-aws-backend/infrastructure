variable "stage" {}

module "serverless-deploy-bucket" {
  source = "./serverless"
  stage = "${var.stage}"
}