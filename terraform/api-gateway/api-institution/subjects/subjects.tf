variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

locals {
  lambdaName = "${var.stage}-java-lambda-institution-subjects"
  lambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.lambdaName}"
}

resource "aws_api_gateway_resource" "subjects" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "subjects"
}

# CORS
module "cors" {
  source = "github.com/squidfunk/terraform-aws-api-gateway-enable-cors"
  version = "0.3.0"

  api_id = "${var.api_id}"
  api_resource_id = "${aws_api_gateway_resource.subjects.id}"
}


# GET
resource "aws_api_gateway_method" "subjects_get" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.subjects.id}"
  http_method = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "subjects_get_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.subjects.id}"
  http_method = "${aws_api_gateway_method.subjects_get.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

# POST
resource "aws_api_gateway_method" "subjects_post" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.subjects.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "subjects_post_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.subjects.id}"
  http_method = "${aws_api_gateway_method.subjects_post.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

# PUT
resource "aws_api_gateway_method" "subjects_put" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.subjects.id}"
  http_method = "PUT"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "subjects_put_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.subjects.id}"
  http_method = "${aws_api_gateway_method.subjects_put.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

# DELETE
resource "aws_api_gateway_method" "subjects_delete" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.subjects.id}"
  http_method = "DELETE"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "subjects_delete_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.subjects.id}"
  http_method = "${aws_api_gateway_method.subjects_delete.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}