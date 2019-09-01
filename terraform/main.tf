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
  profile = "uvsy-terraform-dev"
  region = "${var.region}"
}

provider "aws" {
  version = "~> 2.25"
  profile = "uvsy-terraform-dev"
  alias = "cognito-aws"
  region = "${var.cognito-region}"
}

module "iam" {
  source = "./iam/"
  stage = "${local.stage}"
}

module "api-gw" {
  source = "./api-gateway"
  region = "${var.region}"
  stage = "${local.stage}"
  account_id = "${data.aws_caller_identity.current.account_id}"
  apigw_role_arn = "${module.iam.api-gw-role-arn}"
}