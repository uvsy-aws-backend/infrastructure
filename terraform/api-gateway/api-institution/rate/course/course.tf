variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

locals {
  postLambdaName = "${var.stage}-java-lambda-institution-course-rate-get"
  postLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.postLambdaName}"
}

resource "aws_api_gateway_resource" "course" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "course"
}

resource "aws_api_gateway_method" "course_get" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.course.id}"
  http_method = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "course_get_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.course.id}"
  http_method = "${aws_api_gateway_method.course_get.http_method}"
  integration_http_method = "GET"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.postLambdaArn}/invocations"
}