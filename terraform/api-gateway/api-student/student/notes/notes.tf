variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

locals {
  lambdaName = "${var.stage}-java-lambda-student-notes"
  lambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.lambdaName}"
}

resource "aws_api_gateway_resource" "notes" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "notes"
}


# GET
resource "aws_api_gateway_method" "notes_get" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.notes.id}"
  http_method = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "notes_get_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.notes.id}"
  http_method = "${aws_api_gateway_method.notes_get.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

# POST
resource "aws_api_gateway_method" "notes_post" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.notes.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "notes_post_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.notes.id}"
  http_method = "${aws_api_gateway_method.notes_post.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

# PUT
resource "aws_api_gateway_method" "notes_put" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.notes.id}"
  http_method = "PUT"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "notes_put_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.notes.id}"
  http_method = "${aws_api_gateway_method.notes_put.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

# DELETE
resource "aws_api_gateway_method" "notes_delete" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.notes.id}"
  http_method = "DELETE"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "notes_delete_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.notes.id}"
  http_method = "${aws_api_gateway_method.notes_delete.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}