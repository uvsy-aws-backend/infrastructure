variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

locals {
  postLambdaName = "${var.stage}-java-lambda-account-logon-post"
  postLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.postLambdaName}"
}

resource "aws_api_gateway_resource" "logon" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "logon"
}

resource "aws_api_gateway_method" "logon_post" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.logon.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "logon_post_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.logon.id}"
  http_method = "${aws_api_gateway_method.logon_post.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.postLambdaArn}/invocations"
}
