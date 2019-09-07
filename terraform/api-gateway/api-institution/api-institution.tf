variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "apigw_role_arn" {}


# API Creation
resource "aws_api_gateway_rest_api" "api-institution" {
  name = "${var.stage}-api-institution"

  endpoint_configuration {
    types = [
    "REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "universy" {
  rest_api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  parent_id = "${aws_api_gateway_rest_api.api-institution.root_resource_id}"
  path_part = "universy"
}

resource "aws_api_gateway_resource" "institution" {
  rest_api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  parent_id = "${aws_api_gateway_resource.universy.id}"
  path_part = "institution"
}


# API Endpoints
module "career" {
  source = "./career"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  parent_id = "${aws_api_gateway_resource.institution.id}"
  role_arn = "${var.apigw_role_arn}"
}

module "profile" {
  source = "./profile"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  parent_id = "${aws_api_gateway_resource.institution.id}"
  role_arn = "${var.apigw_role_arn}"
}

module "rate" {
  source = "./rate"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  parent_id = "${aws_api_gateway_resource.institution.id}"
  role_arn = "${var.apigw_role_arn}"
}


# API Deployment
resource "aws_api_gateway_deployment" "api-institution-deploy" {
  depends_on = [
    "module.career",
    "module.profile",
    "module.rate"
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  stage_name  = "${var.stage}"
}


# API Key and Usage Plan
resource "aws_api_gateway_api_key" "api-institution-key" {
  name = "${var.stage}-institution-key"
}

resource "aws_api_gateway_usage_plan" "api-institution-usage-plan" {
  name = "${var.stage}-institution-key-usage-plan"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.api-institution.id}"
    stage  = "${aws_api_gateway_deployment.api-institution-deploy.stage_name}"
  }
}

resource "aws_api_gateway_usage_plan_key" "api-institutions-usage-plan-key" {
  key_id        = "${aws_api_gateway_api_key.api-institution-key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.api-institution-usage-plan.id}"
}