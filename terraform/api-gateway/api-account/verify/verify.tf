variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

locals {
  postLambdaName = "${var.stage}-java-lambda-account-verify-post"
  postLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.postLambdaName}"
  getLambdaName = "${var.stage}-java-lambda-account-verify-get"
  getLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.getLambdaName}"
}

resource "aws_api_gateway_resource" "verify" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "verify"
}

resource "aws_api_gateway_method" "verify_post" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.verify.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "verify_post_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.verify.id}"
  http_method = "${aws_api_gateway_method.verify_post.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.postLambdaArn}/invocations"
}

resource "aws_api_gateway_method" "verify_get" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.verify.id}"
  http_method = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "verify_get_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.verify.id}"
  http_method = "${aws_api_gateway_method.verify_get.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.getLambdaArn}/invocations"
}

