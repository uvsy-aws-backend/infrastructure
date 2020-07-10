data "aws_caller_identity" "current" {
}

provider "aws" {
  version = "~> 2.25"
  profile = "uvsy-dev"
  region = var.region
}


module "serverless-deploy-bucket" {
  source = "./serverless"
  stage = local.stage
  region = var.region
}