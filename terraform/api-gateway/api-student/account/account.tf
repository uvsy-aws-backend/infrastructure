variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}


resource "aws_api_gateway_resource" "account" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "account"
}


# API Endpoints
module "login" {
  source = "./login"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.account.id}"
  role_arn = "${var.role_arn}"
}

module "logon" {
  source = "./logon"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.account.id}"
  role_arn = "${var.role_arn}"
}

module "verify" {
  source = "./verify"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.account.id}"
  role_arn = "${var.role_arn}"
}
