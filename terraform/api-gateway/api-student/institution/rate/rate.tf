variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

resource "aws_api_gateway_resource" "rate" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "rate"
}

module "subject" {
  source = "subject"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.rate.id}"
  role_arn = "${var.role_arn}"
  authorizer_id = "${var.authorizer_id}"
}

module "course" {
  source = "course"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.rate.id}"
  role_arn = "${var.role_arn}"
  authorizer_id = "${var.authorizer_id}"
}