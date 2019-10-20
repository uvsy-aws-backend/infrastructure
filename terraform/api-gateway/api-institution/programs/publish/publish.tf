variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "api_id" {}

variable "parent_id" {}

variable "role_arn" {}

variable "authorizer_id" {}

locals {
  postLambdaName = "${var.stage}-java-lambda-institution-programs-publish-post"
  postLambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.postLambdaName}"
}

resource "aws_api_gateway_resource" "publish" {
  rest_api_id = "${var.api_id}"
  parent_id = "${var.parent_id}"
  path_part = "publish"
}

# CORS
module "cors" {
  source = "github.com/squidfunk/terraform-aws-api-gateway-enable-cors"
  version = "0.3.0"

  api_id = "${var.api_id}"
  api_resource_id = "${aws_api_gateway_resource.publish.id}"
}


# POST
resource "aws_api_gateway_method" "publish_post" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.publish.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "publish_post_lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.publish.id}"
  http_method = "${aws_api_gateway_method.publish_post.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${var.role_arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.postLambdaArn}/invocations"
}