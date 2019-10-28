variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

locals {
  lambdaName = "${var.stage}-java-lambda-institution-programs"
  lambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.lambdaName}"
}

resource "aws_api_gateway_resource" "programs" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "programs"
}

# CORS
module "cors" {
  source = "github.com/squidfunk/terraform-aws-api-gateway-enable-cors"
  version = "0.3.0"

  api_id = "${var.api_id}"
  api_resource_id = "${aws_api_gateway_resource.programs.id}"
}

# GET
resource "aws_api_gateway_method" "programs_get" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.programs.id}"
  http_method = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "programs_get_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.programs.id}"
  http_method = "${aws_api_gateway_method.programs_get.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

# POST
resource "aws_api_gateway_method" "programs_post" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.programs.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "programs_post_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.programs.id}"
  http_method = "${aws_api_gateway_method.programs_post.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

# PUT
resource "aws_api_gateway_method" "programs_put" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.programs.id}"
  http_method = "PUT"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "programs_put_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.programs.id}"
  http_method = "${aws_api_gateway_method.programs_put.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

# DELETE
resource "aws_api_gateway_method" "programs_delete" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.programs.id}"
  http_method = "DELETE"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "programs_delete_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.programs.id}"
  http_method = "${aws_api_gateway_method.programs_delete.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

# /publish
module "publish" {
  source = "./publish"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${var.api_id}"
  parent_id = "${aws_api_gateway_resource.programs.id}"
  role_arn = "${var.role_arn}"
  authorizer_id = "${var.authorizer_id}"
}