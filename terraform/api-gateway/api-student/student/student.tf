variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}


resource "aws_api_gateway_resource" "student" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "student"
}

# Endpoints

module "career" {
  source = "./career"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.student.id}"
  role_arn = "${var.role_arn}"
  authorizer_id = "${var.authorizer_id}"
}

module "profile" {
  source = "./profile"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.student.id}"
  role_arn = "${var.role_arn}"
  authorizer_id = "${var.authorizer_id}"
}

module "rate" {
  source = "./rate"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.student.id}"
  role_arn = "${var.role_arn}"
  authorizer_id = "${var.authorizer_id}"
}

module "session" {
  source = "./session"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.student.id}"
  role_arn = "${var.role_arn}"
  authorizer_id = "${var.authorizer_id}"
}

module "events" {
  source = "./events"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.student.id}"
  role_arn = "${var.role_arn}"
  authorizer_id = "${var.authorizer_id}"
}

module "notes" {
  source = "./notes"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.student.id}"
  role_arn = "${var.role_arn}"
  authorizer_id = "${var.authorizer_id}"
}