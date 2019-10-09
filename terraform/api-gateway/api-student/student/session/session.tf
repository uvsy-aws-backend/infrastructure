variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

locals {
  getLambdaName = "${var.stage}-java-lambda-student-session-get"
  getLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.getLambdaName}"

  postLambdaName = "${var.stage}-java-lambda-student-session-post"
  postLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.postLambdaName}"
}

resource "aws_api_gateway_resource" "session" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "session"
}

# GET
resource "aws_api_gateway_method" "session_get" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.session.id}"
  http_method = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "session_get_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.session.id}"
  http_method = "${aws_api_gateway_method.session_get.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.getLambdaArn}/invocations"
}

# POST
resource "aws_api_gateway_method" "session_post" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.session.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "session_post_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.session.id}"
  http_method = "${aws_api_gateway_method.session_post.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.postLambdaArn}/invocations"
}