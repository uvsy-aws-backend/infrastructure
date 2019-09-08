variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "apigw_role_arn" {}

module "api-account" {
  source = "./api-account"
  stage = "${var.stage}"
  account_id = "${var.account_id}"
  region = "${var.region}"
  apigw_role_arn = "${var.apigw_role_arn}"
}

module "api-institution" {
  source = "./api-institution"
  stage = "${var.stage}"
  account_id = "${var.account_id}"
  region = "${var.region}"
  apigw_role_arn = "${var.apigw_role_arn}"
}

module "api-student" {
  source = "./api-student"
  stage = "${var.stage}"
  account_id = "${var.account_id}"
  region = "${var.region}"
  apigw_role_arn = "${var.apigw_role_arn}"
}