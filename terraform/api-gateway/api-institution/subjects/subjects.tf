variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

locals {
  getLambdaName = "${var.stage}-java-lambda-institution-subjects-get"
  getLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.getLambdaName}"
  
  postLambdaName = "${var.stage}-java-lambda-institution-subjects-post"
  postLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.postLambdaName}"
  
  putLambdaName = "${var.stage}-java-lambda-institution-subjects-put"
  putLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.putLambdaName}"
  
  deleteLambdaName = "${var.stage}-java-lambda-institution-subjects-delete"
  deleteLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.deleteLambdaName}"
}

resource "aws_api_gateway_resource" "subjects" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "subjects"
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
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.getLambdaArn}/invocations"
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
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.postLambdaArn}/invocations"
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
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.putLambdaArn}/invocations"
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
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.deleteLambdaArn}/invocations"
}