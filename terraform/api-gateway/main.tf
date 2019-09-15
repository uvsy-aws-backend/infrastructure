variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "cognito-region" {}

variable "apigw_role_arn" {}

variable "cognito_user_pool_id" {}

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
  cognito-region = "${var.cognito-region}"
  apigw_role_arn = "${var.apigw_role_arn}"
  cognito_user_pool_id = "${var.cognito_user_pool_id}"
}

module "api-student" {
  source = "./api-student"
  stage = "${var.stage}"
  account_id = "${var.account_id}"
  region = "${var.region}"
  cognito-region = "${var.cognito-region}"
  apigw_role_arn = "${var.apigw_role_arn}"
  cognito_user_pool_id = "${var.cognito_user_pool_id}"
}