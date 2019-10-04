variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

locals {
  postLambdaName = "${var.stage}-java-lambda-institution-profile-get"
  postLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.postLambdaName}"
}

resource "aws_api_gateway_resource" "profile" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "profile"
}

resource "aws_api_gateway_method" "profile_get" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.profile.id}"
  http_method = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "profile_get_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.profile.id}"
  http_method = "${aws_api_gateway_method.profile_get.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.postLambdaArn}/invocations"
}