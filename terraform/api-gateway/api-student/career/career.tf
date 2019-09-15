variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

locals {
  getLambdaName = "${var.stage}-java-lambda-student-career-get"
  getLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.getLambdaName}"

  postLambdaName = "${var.stage}-java-lambda-student-career-post"
  postLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.postLambdaName}"

  putLambdaName = "${var.stage}-java-lambda-student-career-put"
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
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${var.authorizer_id}"
  api_key_required = true
}

resource "aws_api_gateway_integration" "career_get_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.career.id}"
  http_method = "${aws_api_gateway_method.career_get.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.getLambdaArn}/invocations"
}

# POST
resource "aws_api_gateway_method" "career_post" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.career.id}"
  http_method = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${var.authorizer_id}"
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
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${var.authorizer_id}"
  api_key_required = true
}

resource "aws_api_gateway_integration" "career_put_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.career.id}"
  http_method = "${aws_api_gateway_method.career_put.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.putLambdaArn}/invocations"
}


