variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

resource "aws_api_gateway_resource" "institution" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "institution"
}

# API Endpoints

module "root" {
  source = "./root"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.institution.id}"
  role_arn = "${var.role_arn}"
  authorizer_id = "${var.authorizer_id}"
}

module "subjects" {
  source = "./subjects"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.institution.id}"
  role_arn = "${var.role_arn}"
  authorizer_id = "${var.authorizer_id}"
}

module "courses" {
  source = "./courses"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.institution.id}"
  role_arn = "${var.role_arn}"
  authorizer_id = "${var.authorizer_id}"
}

module "rate" {
  source = "./rate"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.institution.id}"
  role_arn = "${var.role_arn}"
  authorizer_id = "${var.authorizer_id}"
}

