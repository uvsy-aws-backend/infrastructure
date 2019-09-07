variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

locals {
  getLambdaName = "${var.stage}-java-lambda-institution-career-get"
  getLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.getLambdaName}"

  postLambdaName = "${var.stage}-java-lambda-student-career-post"
  postLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.postLambdaName}"

  putLambdaName = "${var.stage}-java-lambda-institution-career-put"
  putLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.putLambdaName}"
}

resource "aws_api_gateway_resource" "career" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "career"
}

# GET
resource "aws_api_gateway_method" "career_get" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.career.id}"
  http_method = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "career_get_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.career.id}"
  http_method = "${aws_api_gateway_method.career_get.http_method}"
  integration_http_method = "GET"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.getLambdaArn}/invocations"
}

# POST
resource "aws_api_gateway_method" "career_post" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.career.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "career_post_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.career.id}"
  http_method = "${aws_api_gateway_method.career_post.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.postLambdaArn}/invocations"
}

# PUT
resource "aws_api_gateway_method" "career_put" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.career.id}"
  http_method = "PUT"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "career_put_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.career.id}"
  http_method = "${aws_api_gateway_method.career_put.http_method}"
  integration_http_method = "PUT"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.putLambdaArn}/invocations"
}


