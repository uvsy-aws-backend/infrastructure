variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

locals {
  lambdaName = "${var.stage}-java-lambda-student-events"
  lambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.lambdaName}"
}

resource "aws_api_gateway_resource" "events" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "events"
}


# GET
resource "aws_api_gateway_method" "events_get" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.events.id}"
  http_method = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "events_get_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.events.id}"
  http_method = "${aws_api_gateway_method.events_get.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

# POST
resource "aws_api_gateway_method" "events_post" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.events.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "events_post_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.events.id}"
  http_method = "${aws_api_gateway_method.events_post.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

# PUT
resource "aws_api_gateway_method" "events_put" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.events.id}"
  http_method = "PUT"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "events_put_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.events.id}"
  http_method = "${aws_api_gateway_method.events_put.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

# DELETE
resource "aws_api_gateway_method" "events_delete" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.events.id}"
  http_method = "DELETE"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "events_delete_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.events.id}"
  http_method = "${aws_api_gateway_method.events_delete.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}