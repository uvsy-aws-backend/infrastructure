variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

locals {
  getLambdaName = "${var.stage}-java-lambda-student-subject-rate-get"
  getLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.getLambdaName}"

  postLambdaName = "${var.stage}-java-lambda-student-subject-rate-post"
  postLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.postLambdaName}"
}

resource "aws_api_gateway_resource" "subject" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "subject"
}

# GET
resource "aws_api_gateway_method" "subject_get" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.subject.id}"
  http_method = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${var.authorizer_id}"
  api_key_required = true
}

resource "aws_api_gateway_integration" "subject_get_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.subject.id}"
  http_method = "${aws_api_gateway_method.subject_get.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.getLambdaArn}/invocations"
}

# POST
resource "aws_api_gateway_method" "subject_post" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.subject.id}"
  http_method = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${var.authorizer_id}"
  api_key_required = true
}

resource "aws_api_gateway_integration" "subject_post_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.subject.id}"
  http_method = "${aws_api_gateway_method.subject_post.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.postLambdaArn}/invocations"
}