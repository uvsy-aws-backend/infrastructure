variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

locals {
  lambdaName = "${var.stage}-java-lambda-institution"
  lambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.lambdaName}"
}

# CORS
module "cors" {
  source = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.1"

  api_id = "${var.api_id}"
  api_resource_id = "${var.parent_id}"
}

# GET
resource "aws_api_gateway_method" "institution_get" {
  rest_api_id = "${var.api_id}"
  resource_id = "${var.parent_id}"
  http_method = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "institution_get_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${var.parent_id}"
  http_method = "${aws_api_gateway_method.institution_get.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}