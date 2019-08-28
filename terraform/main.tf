
locals {
  stage = "${terraform.workspace}"
}

data "aws_caller_identity" "current" {

}

variable "region" {
  default = "us-east-1"
}

variable "cognito-region" {
  default = "us-east-1"
}

provider "aws" {
  version = "~> 2.25"
  region = "${var.region}"
}

provider "aws" {
  version = "~> 2.25"
  alias = "cogito-aws"
  region = "${var.cognito-region}"
}

module "api-gateway" {
  source = "./api-gateway"
  providers = {
    aws = "aws"
  }
  stage = "${local.stage}"
  region = "${var.region}"
  account_id = "${data.aws_caller_identity.current.account_id}"
}


