variable "account_id" {}

variable "stage" {}

variable "region" {}

locals {
  lambdaName = "${var.stage}-java-lambda-institutions-get"
  lambdaArn = "arn:aws:lambda:${var.region}:${var.account_id}:function:${local.lambdaName}"
}

resource "aws_api_gateway_rest_api" "api-account" {
  name = "${var.stage}-api-account"

  endpoint_configuration {
    types = [
      "REGIONAL"]
  }
}

resource "aws_api_gateway_api_key" "account-key" {
  name = "${var.stage}-account-key"
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = "${aws_api_gateway_rest_api.api-account.id}"
  parent_id = "${aws_api_gateway_rest_api.api-account.root_resource_id}"
  path_part = "universy"

}

resource "aws_api_gateway_method" "get" {
  rest_api_id = "${aws_api_gateway_rest_api.api-account.id}"
  resource_id = "${aws_api_gateway_resource.root.id}"
  http_method = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = "${aws_api_gateway_rest_api.api-account.id}"
  resource_id = "${aws_api_gateway_resource.root.id}"
  http_method = "${aws_api_gateway_method.get.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  credentials = "${aws_iam_role.api-gw-lambda.arn}"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${local.lambdaArn}/invocations"
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "Grant execution for all aws lambda"

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Sid":"",
         "Effect":"Allow",
         "Action":"lambda:InvokeFunction",
         "Resource":"*"
      }
   ]
}
EOF
}


resource "aws_iam_role" "api-gw-lambda" {
  name = "apigw-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  EOF
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "apigw-lambda-role-attachment"
  roles      = ["${aws_iam_role.api-gw-lambda.name}"]
  policy_arn = "${aws_iam_policy.lambda_policy.arn}"
}