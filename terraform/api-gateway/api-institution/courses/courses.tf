variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

locals {
  getLambdaName = "${var.stage}-java-lambda-institution-courses-get"
  getLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.getLambdaName}"
  
  postLambdaName = "${var.stage}-java-lambda-institution-courses-post"
  postLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.postLambdaName}"
  
  putLambdaName = "${var.stage}-java-lambda-institution-courses-put"
  putLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.putLambdaName}"
  
  deleteLambdaName = "${var.stage}-java-lambda-institution-courses-delete"
  deleteLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.deleteLambdaName}"
}

resource "aws_api_gateway_resource" "courses" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "courses"
}


# CORS
module "cors" {
  source = "github.com/squidfunk/terraform-aws-api-gateway-enable-cors"
  version = "0.3.0"

  api_id = "${var.api_id}"
  api_resource_id = "${aws_api_gateway_resource.courses.id}"
}

# GET
resource "aws_api_gateway_method" "courses_get" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.courses.id}"
  http_method = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "courses_get_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.courses.id}"
  http_method = "${aws_api_gateway_method.courses_get.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.getLambdaArn}/invocations"
}

# POST
resource "aws_api_gateway_method" "courses_post" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.courses.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "courses_post_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.courses.id}"
  http_method = "${aws_api_gateway_method.courses_post.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.postLambdaArn}/invocations"
}

# PUT
resource "aws_api_gateway_method" "courses_put" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.courses.id}"
  http_method = "PUT"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "courses_put_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.courses.id}"
  http_method = "${aws_api_gateway_method.courses_put.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.putLambdaArn}/invocations"
}

# DELETE
resource "aws_api_gateway_method" "courses_delete" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.courses.id}"
  http_method = "DELETE"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "courses_delete_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.courses.id}"
  http_method = "${aws_api_gateway_method.courses_delete.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.deleteLambdaArn}/invocations"
}